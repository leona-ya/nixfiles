{ lib, config, currentHost ? config.networking.hostName, ... }:
with lib;
let
  getHosts = hostnames: hosts:
    builtins.map (hostname: getAttrFromPath [ hostname ] hosts) hostnames;
in rec {
  hosts = {

    beryl = {
      meta = {
        intIpv6 = "fd8f:d15b:9f40:c41:5054:ff:fe4e:5cbf";
        hasPublicIpv4 = false;
        hasPublicIpv6 = false;
      };
      charon = {
        "internal" = {
          mac = "52:54:00:4e:5c:bf";
          legacyAddress = "10.151.20.11";
        };
        "internet" = {
          mac = "52:54:00:ba:40:5c";
          duid = "00:02:00:00:ab:11:fd:dc:c3:f1:66:4a:de:40";
          legacyAddress = "195.39.247.145";
          address = "2a01:4f9:6a:13c6:4000::b33";
        };
      };
    };
    charon = {
      meta = {
        intIpv6 = "fd8f:d15b:9f40:0c40::1";
        hasPublicIpv4 = false;
        hasPublicIpv6 = true;
      };
      services = {
        wireguard = {
          interfaces = {
            "server" = {
              ips = [ "10.151.20.254/32" "fd8f:d15b:9f40:0c40::1/60" ];
              publicKey = "Gz1LGMs9bVKEjP2tcX47hkcEHQKGTtqfCvcFcS0G1ic=";
              routed = [ "fd8f:d15b:9f40:0c40::/60" ];
#              routed = [ "fd8f:d15b:9f40:0c40::/60" "10.151.20.0/22" ];
              hostname = "charon.net.leona.is";
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
              routed = [ "fd8f:d15b:9f40:100::/56" "10.151.4.0/22" ];
              #              additonalInterfaceRoutes = [
              #                { routeConfig.Destination = "10.151.8.0/22"; }
              #                { routeConfig.Destination = "10.151.16.0/24"; }
              #              ];
            };
          };
        };
      };
    };
    foros = {
      meta = {
        intIpv6 = "fd8f:d15b:9f40:c41:5054:ff:fe3a:685c";
        hasPublicIpv4 = true;
        hasPublicIpv6 = true;
      };
      charon = {
        "internal" = {
          mac = "52:54:00:3a:68:5c";
          legacyAddress = "10.151.20.12";
        };
        "internet" = {
          mac = "52:54:00:b9:bf:c9";
          duid = "00:02:00:00:ab:11:3e:d1:15:72:fd:15:44:a2";
          legacyAddress = "195.39.247.144";
          address = "2a01:4f9:6a:13c6:4000::dea";
        };
      };
    };
    kupe = {
      meta = {
        intIpv6 = "fd8f:d15b:9f40:c41:5054:ff:feb8:649c";
        hasPublicIpv4 = true;
        hasPublicIpv6 = true;
      };
      charon = {
        "internal" = {
          mac = "52:54:00:b8:64:9c";
          legacyAddress = "10.151.20.10";
        };
        "internet" = {
          mac = "52:54:00:91:96:da";
          legacyAddress = "195.39.247.146";
          duid = "00:02:00:00:ab:11:42:d3:0e:0a:64:85:2c:2a";
          address = "2a01:4f9:6a:13c6:4000::e9c";
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
          routed = [ "fd8f:d15b:9f40::/56" "10.151.0.0/22" ];
          #          additonalInterfaceRoutes = [
          #            { routeConfig.Destination = "10.151.8.0/22"; }
          #            { routeConfig.Destination = "10.151.16.0/24"; }
          #          ];
        };
      };
    };
    hack = {
      meta = {
        intIpv6 = "fd8f:d15b:9f40:c41:5054:ff:feef:6dc3";
        hasPublicIpv4 = false;
        hasPublicIpv6 = true;
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
        hasPublicIpv4 = true;
        hasPublicIpv6 = true;
      };
      services = {
        wireguard = {
          interfaces = {
            "server" = {
              ips = [ "${hosts.haku.meta.intIpv6}/72" ];
              publicKey = "376YjLMEUFHWFE5Xkn3qRyIQ/kAHzM4DhvIcC5boCQ8=";
              routed = [ "fd8f:d15b:9f40::/48" "10.151.0.0/16" ];
              hostname = "haku.net.leona.is";
              interfaceRoutes = [
                { routeConfig.Destination = "10.151.0.0/21"; }
                { routeConfig.Destination = "10.151.20.0/22"; }
                { routeConfig.Destination = "fd8f:d15b:9f40::/53"; }
                { routeConfig.Destination = "fd8f:d15b:9f40:0c00::/54"; }
              ];
            };
            "public" = {
              ips = [ "2a0f:4ac0:1e0::1/128" ];
              publicKey = "aY/jNzJUjtohM2yoYSsDRnZyRppcxFHyw9AiDIV7cxQ=";
              routed = [ "195.39.247.144/28" "2a0f:4ac0:1e0::/48" ];
              interfaceRoutes = [
                { routeConfig.Destination = "195.39.247.144/28"; }
                { routeConfig.Destination = "2a0f:4ac0:1e0::/48"; }
              ];
              extraWireguardPeers = [
                { # turingmachine
                  wireguardPeerConfig = {
                    AllowedIPs =
                      [ "195.39.247.148/32" "2a0f:4ac0:1e0:100::/64" ];
                    PublicKey = "jG5oAuO9PHsMHwzyEbX2y3aBYcs6A24DbxvoNcRtZhc=";
                    PersistentKeepalive = 21;
                  };
                }
                { # charon
                  wireguardPeerConfig = {
                    Endpoint = "charon.net.leona.is:51440";
                    AllowedIPs = [
                      "195.39.247.144/32"
                      "195.39.247.145/32"
                      "195.39.247.146/32"
                      "195.39.247.147/32"
                      "195.39.247.149/32"
                      "195.39.247.150/32"
                    ];
                    PublicKey = "d0XoFQpOo0rR1RRTsnBIo6sNb+pT0MOThCSnaLQ4jRQ=";
                    PersistentKeepalive = 21;
                  };
                }
                { # dwd
                  wireguardPeerConfig = {
                    AllowedIPs = [ "195.39.247.151/32" "2a0f:4ac0:1e0:20::/60" ];
                    PublicKey = "3SB96yLcWFrEpGPzeLGhPaDyDOmQj5uLLAPL2Mo9jQs=";
                    PersistentKeepalive = 21;
                  };
                }
              ];
            };
          };
        };
      };
    };
    ladon = {
      meta = {
        intIpv6 = "fd8f:d15b:9f40:c41:5054:ff:fea0:d52c";
        hasPublicIpv4 = true;
        hasPublicIpv6 = true;
      };
      charon = {
        "internal" = {
          mac = "52:54:00:a0:d5:2c";
          legacyAddress = "10.151.20.14";
        };
        "internet" = {
          mac = "52:54:00:95:2b:ad";
          duid = "00:02:00:00:ab:11:04:34:f2:90:13:d2:8f:da";
          legacyAddress = "195.39.247.147";
          address = "2a01:4f9:6a:13c6:4000::f00";
        };
      };
    };
    laurel = {
      meta = {
        intIpv6 = "fd8f:d15b:9f40:c41:5054:ff:fe0a:845";
        hasPublicIpv4 = true;
        hasPublicIpv6 = true;
      };
      charon = {
        "internal" = {
          mac = "52:54:00:0a:08:45";
          legacyAddress = "10.151.20.15";
        };
        "internet" = {
          mac = "52:54:00:20:44:2b";
          legacyAddress = "195.39.247.149";
          duid = "00:02:00:00:ab:11:7b:cd:e2:8a:79:e8:dd:ea";
          address = "2a01:4f9:6a:13c6:4000::eaa";
        };
      };
    };
    naiad = {
      meta = {
        intIpv6 = "fd8f:d15b:9f40:0c20::1";
        hasPublicIpv4 = true;
        hasPublicIpv6 = true;
      };
      services = {
        wireguard = {
          interfaces = {
            "server" = {
              ips = [ "${hosts.naiad.meta.intIpv6}/72" ];
              publicKey = "duhZn+JOja6bILYxs6D2dKQk7GhmflSsqr+AMOVqJkg=";
              routed = [ "fd8f:d15b:9f40:0c20::1/72" ];
              hostname = "naiad.net.leona.is";
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
  };
  groups =
    (recursiveUpdate (builtins.fromJSON (builtins.readFile ./groups.json)) {
      g_public_v4_hostnames = lib.mapAttrsToList (k: v: "${k}.net.leona.is")
        (lib.filterAttrs (k: v: v.meta.hasPublicIpv4) hosts);
      g_public_v6_hostnames = lib.mapAttrsToList (k: v: "${k}.net.leona.is")
        (lib.filterAttrs (k: v: v.meta.hasPublicIpv6) hosts);
      monitoring = {
        g_hostnames = builtins.map (host: "${host}.wg.net.leona.is")
          groups.monitoring.hosts;
      };
      wireguard = {
        interfaces = {
          server = {
            port = 51441;
            routes = [
              { routeConfig.Destination = "fd8f:d15b:9f40::/48"; }
              { routeConfig.Destination = "10.151.0.0/16"; }
            ];
          };
          public = { port = 51440; };
          public-bkp = { port = 51443; };
        };
        g_currenthost_generate_peers = ifName:
          (builtins.map (x:
            let
              ifaceConfig = x.services.wireguard.interfaces.${ifName};
              groupConfig = groups.wireguard.interfaces.${ifName};
            in {
              wireguardPeerConfig = {
                AllowedIPs = [ ifaceConfig.routed ];
                Endpoint = mkIf (ifaceConfig ? hostname)
                  "${ifaceConfig.hostname}:${toString groupConfig.port}";
                PublicKey = ifaceConfig.publicKey;
                PersistentKeepalive = 21;
              };
            }) (builtins.filter (x:
              x.services.wireguard.interfaces.${ifName} ? hostname
              || hosts.${currentHost}.services.wireguard.interfaces.${ifName}
              ? hostname)
              (builtins.filter (x: x.services.wireguard.interfaces ? ${ifName})
                (getHosts
                  (builtins.filter (x: x != currentHost) groups.wireguard.hosts)
                  hosts))));

        g_systemd_network_netdevconfig = mapAttrs' (ifName: value:
          let
            ifaceConfig =
              hosts.${currentHost}.services.wireguard.interfaces.${ifName};
          in nameValuePair "30-wg-${ifName}" {
            netdevConfig = {
              Kind = "wireguard";
              Name = "wg-${ifName}";
            };
            wireguardConfig = {
              ListenPort = groups.wireguard.interfaces.${ifName}.port;
              PrivateKeyFile =
                config.sops.secrets."hosts/${currentHost}/wireguard_wg-${ifName}_privatekey".path;
            };
            wireguardPeers =
              groups.wireguard.g_currenthost_generate_peers ifName
              ++ (if ifaceConfig ? extraWireguardPeers then
                ifaceConfig.extraWireguardPeers
              else
                [ ]);
          }) hosts.${currentHost}.services.wireguard.interfaces;
        g_systemd_network_networkconfig = mapAttrs' (ifName: value:
          let
            ifaceConfig =
              hosts.${currentHost}.services.wireguard.interfaces.${ifName};
            groupConfig = groups.wireguard.interfaces.${ifName};
          in nameValuePair "30-wg-${ifName}" {
            name = "wg-${ifName}";
            linkConfig = { RequiredForOnline = "yes"; };
            networkConfig = { IPForward = true; };
            address = ifaceConfig.ips;
            routes = if ifaceConfig ? interfaceRoutes then
              ifaceConfig.interfaceRoutes
            else
              groupConfig.routes;
          }) hosts.${currentHost}.services.wireguard.interfaces;
      };
    });
  nyan.g_assignments = builtins.mapAttrs (hostname: config: config.nyan)
    (filterAttrs (hostname: config: config ? nyan) hosts);
  charon.g_assignments = builtins.mapAttrs (hostname: config: config.charon)
     (filterAttrs (hostname: config: config ? charon) hosts);
  services = {
    dns-int.g_dns_records = mapAttrs' (hostname: config:
      nameValuePair "${hostname}.wg.net" { AAAA = [ config.meta.intIpv6 ]; })
      (filterAttrs (h: config: config.meta ? intIpv6) hosts) // mapAttrs'
      (hostname: config:
        nameValuePair "${hostname}.nyan.net" {
          A = [ config.nyan.legacyAddress ];
        }) (filterAttrs (hostname: config: config ? nyan) hosts);
  };
}
