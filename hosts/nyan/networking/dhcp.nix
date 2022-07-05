{ lib, config, ... }:

with lib;
with import ../../../lib/ip-util.nix { inherit lib; };
let
  hosthelper = import ../.. { inherit lib config; };
  interfaces = {
    "br-nhp" = {
      legacyPrefixes = {
        "10.151.20.0" = {
          prefixLength = 24;
          start = "10.151.20.100";
          end = "10.151.20.200";
          nameservers = [ "1.1.1.1" ];
          gateway = "10.151.20.254";
        };
      };
      prefix = {
        prefix = "2a01:4f8:242:155f:1000::";
        prefixLength = 68;
        start = "100";
        end = "fff";
        nameservers = [ "2606:4700:4700::1111" ];
      };
      raPrefixes = {
        "fd8f:d15b:9f40:0c31::".prefixLength = 64;
        "2a01:4f8:242:155f:1000::".prefixLength = 68;
      };
    };
    "br-nh" = {
      legacyPrefixes = {
        "10.151.21.0" = {
          prefixLength = 26;
          start = "10.151.21.40";
          end = "10.151.21.60";
          nameservers = [ "1.1.1.1" ];
          gateway = "10.151.21.62";
        };
      };
      prefix = {
        prefix = "2a01:4f8:242:155f:2000::";
        prefixLength = 68;
        start = "100";
        end = "fff";
        nameservers = [ "2606:4700:4700::1111" ];
      };
      raPrefixes = {
        "fd8f:d15b:9f40:0c32::".prefixLength = 64;
        "2a01:4f8:242:155f:2000::".prefixLength = 68;
      };
    };
    "br-n" = {
      legacyPrefixes = {
        "10.151.21.64" = {
          prefixLength = 26;
          start = "10.151.21.100";
          end = "10.151.21.120";
          nameservers = [ "1.1.1.1" ];
          gateway = "10.151.21.126";
        };
      };
      prefix = {
        prefix = "2a01:4f8:242:155f:3000::";
        prefixLength = 68;
        start = "100";
        end = "fff";
        nameservers = [ "2606:4700:4700::1111" ];
      };
      raPrefixes = {
        "2a01:4f8:242:155f:3000::".prefixLength = 68;
      };
    };
    "br-np" = {
      legacyPrefixes = {
        "10.151.21.192" = {
          prefixLength = 26;
          start = "10.151.21.240";
          end = "10.151.21.254";
          nameservers = [ "1.1.1.1" ];
          gateway = "10.151.21.192";
        };
      };
      prefix = {
        prefix = "2a01:4f8:242:155f:4000::";
        prefixLength = 68;
        start = "100";
        end = "fff";
        nameservers = [ "2606:4700:4700::1111" ];
      };
      raPrefixes = {
        "2a01:4f8:242:155f:4000::".prefixLength = 68;
      };
    };
  };
  assignments = hosthelper.nyan.g_assignements;
in {
  l.nftables.extraInput = let
    ifaces = concatStringsSep ", " (
      attrNames interfaces
    );
  in ''
    iifname { ${ifaces} } udp sport bootpc udp dport bootps accept
    iifname { ${ifaces} } icmpv6 type nd-router-solicit accept
    # DHCPv6
    iifname { ${ifaces} } udp dport 547 accept
  '';

  services.dhcpd4 = with ipv4; {
    enable = true;
    interfaces = [ (head (attrNames interfaces)) ];
    extraConfig = let
      mkIface = iface: { legacyPrefixes, ... }: concatStrings (
        mapAttrsToList (
          prefix: { prefixLength, start, end, nameservers, gateway, ... }: ''
            subnet ${prefix} netmask ${netmask prefixLength} {
              range ${start} ${end};
              option domain-name-servers ${concatStringsSep ", " nameservers};
              option routers ${gateway};
              interface ${iface};
            }
          ''
        ) legacyPrefixes
      );

      mkAssignment = hostname: { mac, legacyAddress, ... }: ''
        host ${hostname} {
          hardware ethernet ${mac};
          fixed-address ${legacyAddress};
        }
      '';

    in (
      concatStrings (
        mapAttrsToList mkIface interfaces
          ++
        mapAttrsToList mkAssignment (
          filterAttrs (
            hostname: config: config ? legacyAddress
          ) assignments
        )
      )
    );
  };



  services.dhcpd6 = with ipv6; {
    enable = true;
    interfaces = [ (head (attrNames interfaces)) ];
    extraConfig = let
      mkIface = iface: { prefix, ... }: ''
        subnet6 ${prefix.prefix}/${toString prefix.prefixLength} {
          range6 ${prefix.prefix}${prefix.start} ${prefix.prefix}${prefix.end};
          option dhcp6.name-servers ${concatStringsSep ", " prefix.nameservers};
          interface ${iface};
        }
      '';

      mkAssignment = hostname: { duid, address, ... }: ''
        host ${hostname} {
          host-identifier option dhcp6.client-id ${duid};
          fixed-address6 ${address};
        }
      '';
#          hardware ethernet ${mac};

    in (
      concatStrings (
        mapAttrsToList mkIface interfaces
          ++
        mapAttrsToList mkAssignment (
          filterAttrs (
            hostname: config: config ? address
          ) assignments
        )
      )
    );
  };

  systemd.services.dhcpd6.serviceConfig = {
    AmbientCapabilities = [ "CAP_NET_RAW" ];
  };


  services.radvd = {
    enable = true;
    config = concatStrings (
      mapAttrsToList (
        iface: { raPrefixes, ... }: ''
          interface ${iface} {
            AdvSendAdvert on;
            AdvManagedFlag on;
          ''  + concatStrings (
            mapAttrsToList (
              prefix: { prefixLength, ... }: ''
                prefix ${prefix}/${toString prefixLength} {
                  AdvRouterAddr on;
                };
              ''
            ) raPrefixes
          ) + ''
            };
          ''
      ) interfaces
    );
  };


}
