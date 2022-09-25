{ lib, config, ... }:

with lib;
with import ../../../lib/ip-util.nix { inherit lib; };
let
  hosthelper = import ../.. { inherit lib config; };
  interfaces = {
    "br-internal" = {
      legacyPrefixes = {
        "10.151.20.0" = rec {
          prefixLength = 24;
          start = "10.151.20.100";
          end = "10.151.20.200";
          nameservers = [ "10.151.20.254" ];
          extraConfig = ''
            option rfc3442-classless-static-routes 16, 10, 151, 10, 151, 20, 254;
          '';
        };
      };
      raDNS = "fd8f:d15b:9f40:0c41::1";
      raPrefixes = { "fd8f:d15b:9f40:0c41::".prefixLength = 64; };
      raExtraConfig = ''
        AdvDefaultLifetime 0;
        route fd8f:d15b:9f40::/48 {};
      '';
    };
    "br-internet" = {
      legacyPrefixes = {
        "195.39.247.144" = rec {
          prefixLength = 28;
          gateway = "195.39.247.150";
          extraConfig = ''
            option subnet-mask 255.255.255.255;
          '';
        };
        "100.64.0.0" = rec {
          prefixLength = 24;
          gateway = "100.64.0.254";
          start = "100.64.0.10";
          end = "100.64.0.250";
        };
      };
      prefix = {
        prefix = "2a01:4f9:6a:13c6:4000::";
        prefixLength = 66;
        start = "100";
        end = "fff";
      };
      raPrefixes = { "2a01:4f9:6a:13c6:4000::".prefixLength = 66; };
      raExtraConfig = ''
        AdvManagedFlag on;
      '';
    };
  };
  assignments = hosthelper.charon.g_assignments;
in {
  l.nftables.extraInput =
    let ifaces = concatStringsSep ", " (attrNames interfaces);
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
      mkIface = iface:
        { legacyPrefixes, ... }:
        ''
          shared-network ${iface} {
            interface ${iface};
        '' + concatStrings ( mapAttrsToList (prefix: values:
          ''
            subnet ${prefix} netmask ${netmask values.prefixLength} {
          '' + optionalString (values ? start && values ? end) ''
            range ${values.start} ${values.end};
          '' + optionalString (values ? nameservers) ''
            option domain-name-servers ${
              concatStringsSep ", " values.nameservers
            };
          '' + optionalString (values ? gateway) ''
            option routers ${values.gateway};
          '' + optionalString (values ? extraConfig) ''
            ${values.extraConfig}
          '' + ''
            }
          '') legacyPrefixes)  + "\n}\n";

      mkAssignment = { name, mac, legacyAddress, ... }: ''
        host ${name} {
          hardware ethernet ${mac};
          fixed-address ${legacyAddress};
        }
      '';

    in ''
      option rfc3442-classless-static-routes code 121 = array of unsigned integer 8;
    '' + (concatStrings (mapAttrsToList mkIface interfaces
      ++ (builtins.map mkAssignment (flatten (lib.mapAttrsToList
        (hostname: config:
          (lib.mapAttrsToList (iface:
            { mac, legacyAddress, ... }: {
              name = hostname + "-" + iface;
              mac = mac;
              legacyAddress = legacyAddress;
            }) (lib.filterAttrs (hostname: config: config ? legacyAddress)
              config))) assignments)))));
  };

  services.dhcpd6 = with ipv6; {
    enable = true;
    interfaces = [ (head (attrNames interfaces)) ];
    extraConfig = let
      mkIface = iface:
        { prefix, ... }:
        ''
          subnet6 ${prefix.prefix}/${toString prefix.prefixLength} {
            range6 ${prefix.prefix}${prefix.start} ${prefix.prefix}${prefix.end};
        '' + optionalString (prefix ? nameservers) ''
          option dhcp6.name-servers ${concatStringsSep ", " prefix.nameservers};
        '' + ''
            interface ${iface};
          }
        '';

      mkAssignment = { name, duid, address, ... }: ''
        host ${name} {
          host-identifier option dhcp6.client-id ${duid};
          fixed-address6 ${address};
        }
      '';

    in (concatStrings (mapAttrsToList mkIface
      (filterAttrs (name: config: config ? prefix) interfaces)
      ++ (builtins.map mkAssignment (flatten (lib.mapAttrsToList
        (hostname: config:
          (lib.mapAttrsToList (iface:
            { duid, address, ... }: {
              name = hostname + "-" + iface;
              duid = duid;
              address = address;
            }) (lib.filterAttrs (hostname: config: config ? address) config)))
        assignments)))));
  };

  systemd.services.dhcpd6.serviceConfig = {
    AmbientCapabilities = [ "CAP_NET_RAW" ];
  };

  services.radvd = {
    enable = true;
    config = concatStrings (mapAttrsToList (iface: ifaceConfig:
      ''
        interface ${iface} {
          AdvSendAdvert on;
      '' + concatStrings (mapAttrsToList (prefix:
        { prefixLength, ... }: ''
          prefix ${prefix}/${toString prefixLength} {
            AdvRouterAddr on;
          };
        '') ifaceConfig.raPrefixes) + optionalString (ifaceConfig ? raDNS) ''
          RDNSS ${ifaceConfig.raDNS} {};
        '' + optionalString (ifaceConfig ? raExtraConfig) ''
           ${ifaceConfig.raExtraConfig}
        '' + ''
          };
        '') interfaces);
  };

}
