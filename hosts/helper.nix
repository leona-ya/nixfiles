{
  lib,
  config,
  currentHost ? config.networking.hostName,
  ...
}:
with lib;
let
  getHosts = hostnames: hosts: builtins.map (hostname: getAttrFromPath [ hostname ] hosts) hostnames;
in
rec {
  hosts = {
    biro = {
      meta = {
        intIpv6 = "fd8f:d15b:9f40:0c21::1";
        hasPublicIpv4 = true;
        hasPublicIpv6 = true;
      };
      services = {
        wireguard = {
          interfaces = {
            "clients" = {
              ips = [
                "10.151.9.1/32"
                "fd8f:d15b:9f40:0900::1/64"
              ];
              publicKey = "ULV9Pt0i4WHZ1b1BNS8vBa2e9Lx1MR3DWF8sW8HM1Wo=";
              routed = [
                "fdf8:d15b:9f40::/48"
                "10.151.0.0/16"
              ];
              interfaceRoutes = [
                { Destination = "10.151.9.0/24"; }
                { Destination = "fd8f:d15b:9f40:0900::/56"; }
              ];
              extraWireguardPeers = [
                {
                  # nyx
                  AllowedIPs = [
                    "10.151.9.3/32"
                    "fd8f:d15b:9f40:0901:200::1/72"
                  ];
                  PublicKey = "MdSVqYNSF2Lylb1kTdfW33ZwQcGff1ueQRrjiPeqDVg=";
                }
                {
                  # edlu
                  AllowedIPs = [
                    "10.151.9.4/32"
                    "fd8f:d15b:9f40:0901:100::1/72"
                  ];
                  PublicKey = "NzCAPjJp7TAR98KkJd1glJwZNdEWUnDzPt3KdNId0Xc=";
                }
                {
                  # freyda
                  AllowedIPs = [
                    "10.151.9.7/32"
                    "fd8f:d15b:9f40:0901:300::1/72"
                  ];
                  PublicKey = "1ZhRSfPcAbEYVk3AYuHjDj+6VoxgU4VbSHQqoj5TB0o=";
                }
                {
                  # Luna [DM]
                  AllowedIPs = [
                    "10.151.9.5/32"
                    "fd8f:d15b:9f40:0902::1/72"
                  ];
                  PublicKey = "0tlj84AXn/vVl7fAkgKsDcAcW3CN4y92sr/MKL9TBRI=";
                }
                {
                  # Luna Phone [DM]
                  AllowedIPs = [
                    "10.151.9.6/32"
                    "fd8f:d15b:9f40:0902:100::1/72"
                  ];
                  PublicKey = "C8MU9Zqx740SjEYPjzIgCOlbe/D6HkDU+Vh6XwVMhFg=";
                }
              ];
            };
            "server" = {
              ips = [
                "${hosts.biro.meta.intIpv6}/72"
                "10.151.9.1/32"
              ];
              publicKey = "2u8sWyQsqtg13Ze1+m1X3r2Jg84OkkdDAgvSc1Q10Tc=";
              routed = [
                "fd8f:d15b:9f40::/48"
                "10.151.0.0/16"
              ];
              hostname = "biro.net.leona.is";
              interfaceRoutes = [
                { Destination = "10.151.0.0/22"; }
                { Destination = "10.151.4.0/22"; }
                { Destination = "fd8f:d15b:9f40::/53"; }
                { Destination = "fd8f:d15b:9f40:0c00::/54"; }
              ];
            };
          };
        };
      };
    };
    dwd = {
      meta = {
        intIpv6 = "fd8f:d15b:9f40:100::1";
        hasPublicIpv4 = false;
        hasPublicIpv6 = false;
      };
      services = {
        wireguard = {
          interfaces = {
            "server" = {
              ips = [ "${hosts.dwd.meta.intIpv6}/56" ];
              publicKey = "8Jzx9hklD8g6colimGybv9kpC2q0oTIgrISGhLd0QEM=";
              routed = [
                "fd8f:d15b:9f40:100::/56"
                "10.151.4.0/22"
              ];
            };
          };
        };
      };
    };
    enari = {
      meta = {
        intIpv6 = "fd8f:d15b:9f40:c10::1";
        hasPublicIpv4 = true;
        hasPublicIpv6 = true;
      };
      services = {
        wireguard = {
          interfaces = {
            "server" = {
              ips = [ "${hosts.enari.meta.intIpv6}/72" ];
              publicKey = "JbZutdoQLIZaHn89QskIw1TW59x+DcJrUG8nLjndaQk=";
              routed = [ "${hosts.enari.meta.intIpv6}/72" ];
              hostname = "enari.net.leona.is";
            };
          };
        };
      };
    };
    rutile = {
      meta = {
        intIpv6 = "fd8f:d15b:9f40:c11::1";
        hasPublicIpv4 = true;
        hasPublicIpv6 = true;
      };
      services = {
        wireguard = {
          interfaces = {
            "server" = {
              ips = [ "${hosts.rutile.meta.intIpv6}/72" ];
              publicKey = "umq4IjePohYh2E+DScbKQw9Cy5b8QBPwjWdtoyXt4hk=";
              routed = [ "${hosts.rutile.meta.intIpv6}/72" ];
              hostname = "rutile.net.leona.is";
            };
          };
        };
      };
    };
    kupe = {
      meta = {
        intIpv6 = "fd8f:d15b:9f40:c21:300::1";
        hasPublicIpv4 = true;
        hasPublicIpv6 = true;
      };
      services = {
        wireguard = {
          interfaces = {
            "server" = {
              ips = [ "${hosts.kupe.meta.intIpv6}/72" ];
              publicKey = "g2gq/9nAYSHx4NidfN/w8uQXX8SXoi2S0qQfN+ascAY=";
              routed = [ "${hosts.kupe.meta.intIpv6}/72" ];
              hostname = "kupe.net.leona.is";
            };
          };
        };
      };
    };
    gaika = {
      meta = {
        intIpv6 = "fd8f:d15b:9f40:10:11:32ff:fe2a:888e";
        hasPublicIpv4 = false;
        hasPublicIpv6 = false;
      };
      services.wireguard.interfaces = {
        "server" = {
          ips = [ "${hosts.gaika.meta.intIpv6}/56" ];
          publicKey = "rn6dN9VdCiYMaNcP7eiCUuOB103OpIAva08EPklNfgo=";
          routed = [
            "fd8f:d15b:9f40::/56"
            "10.151.0.0/22"
          ];
        };
      };
    };
    hack = {
      meta = {
        intIpv6 = "fd8f:d15b:9f40:c41:5054:ff:feef:6dc3";
        hasPublicIpv4 = false;
        hasPublicIpv6 = false;
      };
      nyan = {
        mac = "52:54:00:65:7a:8e";
        duid = "00:02:00:00:ab:11:83:85:8b:4d:78:f2:6f:1d";
        legacyAddress = "10.151.20.13";
        address = "2a01:4f8:242:155f:1000::fc5";
      };
    };
    haku = {
      meta = {
        intIpv6 = "fd8f:d15b:9f40:0c00::1";
        hasPublicIpv4 = false;
        hasPublicIpv6 = false;
      };
      services = {
        wireguard = {
          interfaces = {
            "server" = {
              ips = [ "${hosts.haku.meta.intIpv6}/72" ];
              publicKey = "376YjLMEUFHWFE5Xkn3qRyIQ/kAHzM4DhvIcC5boCQ8=";
              routed = [ "fd8f:d15b:9f40:0c00::/72" ];
              hostname = "haku.net.leona.is";
              interfaceRoutes = [
                { Destination = "fd8f:d15b:9f40::/53"; }
                { Destination = "fd8f:d15b:9f40:0c00::/54"; }
              ];
            };
            "public" = {
              ips = [ "2a0f:4ac0:1e0::1/128" ];
              publicKey = "aY/jNzJUjtohM2yoYSsDRnZyRppcxFHyw9AiDIV7cxQ=";
              routed = [
                "195.39.247.144/28"
                "2a0f:4ac0:1e0::/48"
              ];
              interfaceRoutes = [
                { Destination = "195.39.247.144/28"; }
                { Destination = "2a0f:4ac0:1e0::/48"; }
              ];
              extraWireguardPeers = [
                {
                  # kupe
                  Endpoint = "kupe.net.leona.is:51440";
                  AllowedIPs = [
                    "195.39.247.146/32"
                  ];
                  PublicKey = "6yX+Sfr6KlIn4ThOcRW9NH5iWhzmr6wrOgwMhxOSnTg=";
                  PersistentKeepalive = 21;
                }
                {
                  # dwd
                  AllowedIPs = [
                    "195.39.247.151/32"
                    "2a0f:4ac0:1e0:20::/60"
                  ];
                  PublicKey = "3SB96yLcWFrEpGPzeLGhPaDyDOmQj5uLLAPL2Mo9jQs=";
                  PersistentKeepalive = 21;
                }
              ];
            };
          };
        };
      };
    };
    fdg-web = {
      meta = {
        hasPublicIpv4 = false;
        hasPublicIpv6 = false;
      };
      nyan = {
        mac = "52:54:00:47:a2:f1";
        duid = "00:02:00:00:ab:11:53:f2:e5:e7:f2:2a:48:54";
        legacyAddress = "10.151.21.193";
        address = "2a01:4f8:242:155f:4000::b8b";
      };
    };
    thia = {
      meta = {
        intIpv6 = "fd8f:d15b:9f40:101::1312";
        hasPublicIpv4 = false;
        hasPublicIpv6 = false;
      };
    };
  };
  groups = (
    recursiveUpdate (builtins.fromJSON (builtins.readFile ./groups.json)) {
      g_public_v4_hostnames = lib.mapAttrsToList (k: v: "${k}.net.leona.is") (
        lib.filterAttrs (k: v: v.meta.hasPublicIpv4) hosts
      );
      g_public_v6_hostnames = lib.mapAttrsToList (k: v: "${k}.net.leona.is") (
        lib.filterAttrs (k: v: v.meta.hasPublicIpv6) hosts
      );
      monitoring = {
        g_hostnames = builtins.map (host: "${host}.wg.net.leona.is") groups.monitoring.hosts;
      };
      wireguard = {
        interfaces = {
          server = {
            port = 51441;
            routes = [
              { Destination = "fd8f:d15b:9f40::/48"; }
              { Destination = "10.151.0.0/16"; }
            ];
          };
          clients = {
            port = 4500;
          };
          public = {
            port = 51440;
          };
        };
        g_currenthost_generate_peers =
          ifName:
          (builtins.map
            (
              x:
              let
                ifaceConfig = x.services.wireguard.interfaces.${ifName};
                groupConfig = groups.wireguard.interfaces.${ifName};
              in
              {
                AllowedIPs = [ ifaceConfig.routed ];
                Endpoint = mkIf (ifaceConfig ? hostname) "${ifaceConfig.hostname}:${toString groupConfig.port}";
                PublicKey = ifaceConfig.publicKey;
                PersistentKeepalive = 21;
              }
            )
            (
              builtins.filter
                (
                  x:
                  x.services.wireguard.interfaces.${ifName} ? hostname
                  || hosts.${currentHost}.services.wireguard.interfaces.${ifName} ? hostname
                )
                (
                  builtins.filter (x: x.services.wireguard.interfaces ? ${ifName}) (
                    getHosts (builtins.filter (x: x != currentHost) groups.wireguard.hosts) hosts
                  )
                )
            )
          );

        g_systemd_network_netdevconfig = mapAttrs' (
          ifName: value:
          let
            ifaceConfig = hosts.${currentHost}.services.wireguard.interfaces.${ifName};
          in
          nameValuePair "30-wg-${ifName}" {
            netdevConfig = {
              Kind = "wireguard";
              Name = "wg-${ifName}";
            };
            wireguardConfig = {
              ListenPort = groups.wireguard.interfaces.${ifName}.port;
              PrivateKeyFile = config.sops.secrets."hosts/${currentHost}/wireguard_wg-${ifName}_privatekey".path;
            };
            wireguardPeers =
              groups.wireguard.g_currenthost_generate_peers ifName
              ++ (if ifaceConfig ? extraWireguardPeers then ifaceConfig.extraWireguardPeers else [ ]);
          }
        ) hosts.${currentHost}.services.wireguard.interfaces;
        g_systemd_network_networkconfig = mapAttrs' (
          ifName: value:
          let
            ifaceConfig = hosts.${currentHost}.services.wireguard.interfaces.${ifName};
            groupConfig = groups.wireguard.interfaces.${ifName};
          in
          nameValuePair "30-wg-${ifName}" {
            name = "wg-${ifName}";
            linkConfig = {
              RequiredForOnline = "yes";
            };
            networkConfig = {
              IPv4Forwarding = true;
              IPv6Forwarding = true;
            };
            address = ifaceConfig.ips;
            routes = if ifaceConfig ? interfaceRoutes then ifaceConfig.interfaceRoutes else groupConfig.routes;
          }
        ) hosts.${currentHost}.services.wireguard.interfaces;
      };
    }
  );
  services = {
    dns-int.g_dns_records = mapAttrs' (
      hostname: config: nameValuePair "${hostname}.wg.net" { AAAA = [ config.meta.intIpv6 ]; }
    ) (filterAttrs (h: config: config.meta ? intIpv6) hosts);
  };
}
