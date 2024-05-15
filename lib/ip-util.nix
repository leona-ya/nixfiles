# by yuka
{ lib ? import <nixpkgs/lib> }:

with lib;

rec {
  # FIXME: add case for negative numbers
  pow = base: exponent: if exponent == 0 then 1 else
  fold
    (
      x: y: y * base
    )
    base
    (
      range 2 exponent
    );

  fromHexString = hex: foldl
    (
      x: y: 16 * x + (
        (
          listToAttrs
            (
              map
                (
                  x: nameValuePair
                    (
                      toString x
                    )
                    x
                )
                (
                  range 0 9
                )
            ) // {
            "a" = 10;
            "b" = 11;
            "c" = 12;
            "d" = 13;
            "e" = 14;
            "f" = 15;
          }
        ).${y}
      )
    ) 0
    (
      stringToCharacters (
        removePrefix "0x" (
          hex
        )
      )
    );

  ipv6 = rec {

    expand = address: (
      replaceStrings [ "::" ] [
        (
          concatStringsSep "0" (
            genList (x: ":") (
              9 - (count (x: x == ":") (stringToCharacters address))
            )
          )
        )
      ]
        address
    ) + (
      if hasSuffix "::" address then
        "0"
      else
        ""
    );

    decode = address: map fromHexString (
      splitString ":" (
        expand address
      )
    );

    encode = address: toLower (
      concatStringsSep ":" (
        map toHexString address
      )
    );

    netmask = prefixLength: encode (
      map
        (
          x:
          if prefixLength > x + 16 then
            (pow 2 16) - 1
          else if prefixLength < x then
            0
          else
            (
              foldl
                (
                  x: y: 2 * x + 1
                ) 0
                (
                  range 1 (prefixLength - x)
                )
            ) * (
              pow 2 (
                16 - (prefixLength - x)
              )
            )
        )
        (
          genList
            (
              x: x * 16
            ) 8
        )
    );

    reverseZone = net: (
      concatStringsSep "." (
        reverseList (
          concatLists (
            map
              (
                x: stringToCharacters (fixedWidthString 4 "0" x)
              )
              (
                splitString ":" (
                  expand net
                )
              )
          )
        )
      )
    ) + ".ip6.arpa";

    networkOf = address: prefixLength: encode (
      zipListsWith bitAnd
        (
          decode address
        )
        (
          decode (netmask prefixLength)
        )
    );

    isInNetwork = net: prefixLength: address: (expand net) == (networkOf address prefixLength);

    /* nixos-specific stuff */

    findOwnAddress = net: prefixLength: config: head (
      filter
        (
          isInNetwork net prefixLength
        )
        (
          configuredAddresses config
        )
    );

    configuredAddresses = config: concatLists (
      mapAttrsToList
        (
          name: iface: map
            (
              addr: addr.address
            )
            iface.ipv6.addresses
        )
        config.networking.interfaces
    );

  };

  ipv4 = rec {

    decode = address: foldl
      (
        x: y: 256 * x + y
      ) 0
      (
        map toInt (
          splitString "." address
        )
      );

    encode = num: concatStringsSep "." (
      map
        (
          x: toString (mod (num / x) 256)
        )
        (
          reverseList (
            genList
              (
                x: pow 2 (x * 8)
              ) 4
          )
        )
    );

    netmask = prefixLength: encode (
      (
        foldl
          (
            x: y: 2 * x + 1
          ) 0
          (
            range 1 prefixLength
          )
      ) * (
        pow 2 (
          32 - prefixLength
        )
      )
    );

    reverseZone = net: (
      concatStringsSep "." (
        reverseList (
          splitString "." net
        )
      )
    ) + ".in-addr.arpa";

    # FIXME limited to <=/24 for new
    nixDnsReverseZone = net: prefixLength: cb: listToAttrs (
      map
        (
          x:
          let
            hostPart = last (
              splitString "." x
            );
          in
          nameValuePair hostPart {
            PTR = cb (concatStringsSep "-" (reverseList (splitString "." x)));
          }
        )
        (
          eachAddress net prefixLength
        )
    );

    eachAddress = net: prefixLength: genList
      (
        x: encode (
          x + (
            decode net
          )
        )
      )
      (
        pow 2 (
          32 - prefixLength
        )
      );

    networkOf = address: prefixLength: encode (
      bitAnd
        (
          decode address
        )
        (
          decode (netmask prefixLength)
        )
    );

    isInNetwork = net: prefixLength: address: net == (networkOf address prefixLength);

    /* nixos-specific stuff */

    findOwnAddress = net: prefixLength: config: head (
      filter
        (
          isInNetwork net prefixLength
        )
        (
          configuredAddresses config
        )
    );

    configuredAddresses = config: concatLists (
      mapAttrsToList
        (
          name: iface: map
            (
              addr: addr.address
            )
            iface.ipv4.addresses
        )
        config.networking.interfaces
    );

  };

}
