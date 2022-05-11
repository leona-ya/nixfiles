{ lib, config, currentHost ? config.networking.hostName, ... }:
with lib;
let
  getHosts = hostnames: hosts:
    builtins.map (hostname: getAttrFromPath [ hostname ] hosts) hostnames;
in rec {
  hosts = {
    adonis = {
      meta = {
        intIpv6 = "fd8f:d15b:9f40:0c10::1";
        hasPublicIpv4 = false;
        hasPublicIpv6 = false;
      };
      services = {
        wireguard = {
          interfaces = {
            "server" = {
              ips = [ "${hosts.dwd.meta.intIpv6}/72" ];
              publicKey = "KVB9uOM1n3VgdhjWzLkXLygMPzg/n+MORLba80EE7Xc=";
              routed = [ "fd8f:d15b:9f40:0c10::1/72" ];
              hostname = "adonis.net.leona.is";
            };
          };
        };
      };
    };
    beryl = {
      meta = {
        intIpv6 = "fd8f:d15b:9f40:c31:5054:ff:fe4e:5cbf";
        hasPublicIpv4 = true;
        hasPublicIpv6 = true;
      };
      nyan = {
        mac = "52:54:00:4e:5c:bf";
        duid = "00:02:00:00:ab:11:fd:dc:c3:f1:66:4a:de:40";
        legacyAddress = "10.151.20.11";
        address = "2a01:4f8:242:155f:1000::b33";
      };
    };
    dwd = {
      meta = {
        intIpv6 = "fd8f:d15b:9f40::1";
        hasPublicIpv4 = false;
        hasPublicIpv6 = false;
      };
      services = {
        wireguard = {
          interfaces = {
            "server" = {
              ips = [ "${hosts.dwd.meta.intIpv6}/56" ];
              publicKey = "8Jzx9hklD8g6colimGybv9kpC2q0oTIgrISGhLd0QEM=";
              routed = [ "fd8f:d15b:9f40::/54" "10.151.0.0/21" ];
              additonalInterfaceRoutes = [
                { routeConfig.Destination = "10.151.8.0/22"; }
                { routeConfig.Destination = "10.151.16.0/24"; }
              ];
            };
          };
        };
      };
    };
    foros = {
      meta = {
        intIpv6 = "fd8f:d15b:9f40:c31:5054:ff:fee7:6ae5";
        hasPublicIpv4 = true;
        hasPublicIpv6 = true;
      };
      nyan = {
       mac = "52:54:00:e7:6a:e5";
       duid = "00:02:00:00:ab:11:82:40:af:d3:85:17:b2:1f";
       legacyAddress = "10.151.20.12";
       address = "2a01:4f8:242:155f:1000::987";
      };
   };
    kupe = {
      meta = {
        intIpv6 = "fd8f:d15b:9f40:c31:5054:ff:fec0:8539";
        hasPublicIpv4 = true;
        hasPublicIpv6 = true;
      };
      nyan = {
        mac = "52:54:00:c0:85:39";
        duid = "00:02:00:00:ab:11:9b:68:58:51:30:82:69:52";
        legacyAddress = "10.151.20.10";
        address = "2a01:4f8:242:155f:1000::f28";
      };
    };
    hack = {
      meta = {
        intIpv6 = "fd8f:d15b:9f40:c31:5054:ff:fe65:7a8e";
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
                { # foros
                  wireguardPeerConfig = {
                    AllowedIPs =
                      [ "195.39.247.144/32" ];
                    PublicKey = "CnswutrDvUJdDIsopjkvjO/SiOrKdx3ob0jvDf0LLFI=";
                    PersistentKeepalive = 21;
                  };
                }
                { # beryl
                  wireguardPeerConfig = {
                    AllowedIPs =
                      [ "195.39.247.145/32" ];
                    PublicKey = "DBfzjdPqk5Ee8OYsqNy2LoM7kvbh8ppmK836jlGz43s=";
                    PersistentKeepalive = 21;
                  };
                }
                { # kupe
                  wireguardPeerConfig = {
                    AllowedIPs =
                      [ "195.39.247.146/32" ];
                    PublicKey = "MTGJvKwt7pofvLbJ2gMoOs8z8qFjt3F3e2crlJMHajQ=";
                    PersistentKeepalive = 21;
                  };
                }
                { # ladon
                  wireguardPeerConfig = {
                    AllowedIPs =
                      [ "195.39.247.147/32" ];
                    PublicKey = "ys2dZHPk2YgdEIOs+dKq/nK3oTX1bBBmAuEsOLSpyi4=";
                    PersistentKeepalive = 21;
                  };
                }
                { # turingmachine
                  wireguardPeerConfig = {
                    AllowedIPs =
                      [ "195.39.247.148/32" "2a0f:4ac0:1e0:100::/64" ];
                    PublicKey = "jG5oAuO9PHsMHwzyEbX2y3aBYcs6A24DbxvoNcRtZhc=";
                    PersistentKeepalive = 21;
                  };
                }
                { # laurel
                  wireguardPeerConfig = {
                    AllowedIPs =
                      [ "195.39.247.149/32"];
                    PublicKey = "0zhic69IA9xKXljBzB4ZqYMmFtLVYZCPw0L65grIaRg=";
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
        intIpv6 = "fd8f:d15b:9f40:c31:5054:ff:fed2:a792";
        hasPublicIpv4 = true;
        hasPublicIpv6 = true;
      };
      nyan = {
        mac = "52:54:00:d2:a7:92";
        duid = "00:02:00:00:ab:11:a9:cf:70:02:82:59:f4:eb";
        legacyAddress = "10.151.20.14";
        address = "2a01:4f8:242:155f:1000::1a2";
      };
    };
    laurel = {
      meta = {
        intIpv6 = "fd8f:d15b:9f40:c31:5054:ff:fe68:7591";
        hasPublicIpv4 = true;
        hasPublicIpv6 = true;
      };
      nyan = {
        mac = "52:54:00:68:75:91";
        duid = "00:02:00:00:ab:11:2f:e7:59:42:ff:d4:ca:5d";
        legacyAddress = "10.151.20.15";
        address = "2a01:4f8:242:155f:1000::b4d";
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
    nyan = {
      meta = {
        intIpv6 = "fd8f:d15b:9f40:0c30::1";
        hasPublicIpv4 = true;
        hasPublicIpv6 = true;
      };
      services = {
        wireguard = {
          interfaces = {
            "server" = {
              ips = [ "10.151.20.254/32" "${hosts.nyan.meta.intIpv6}/60" ];
              publicKey = "AilevKAZRnvQUkJhg/R9APpYUdEbnE1g2BP+FUQwBBI=";
              routed = [ "fd8f:d15b:9f40:0c30::/60" "10.151.20.0/22" ];
              hostname = "nyan.net.leona.is";
            };
          };
        };
      };
    };
    utopia = {
      meta = {
        intIpv6 = "fd8f:d15b:9f40:c32:5054:ff:fe77:e68f";
        hasPublicIpv4 = false;
        hasPublicIpv6 = false;
      };
      nyan = {
        mac = "52:54:00:77:e6:8f";
        duid = "00:02:00:00:ab:11:ca:6f:7a:9e:92:e9:a1:af";
        legacyAddress = "10.151.21.11";
        address = "2a01:4f8:242:155f:2000::c7e";
      };
    };
  };
  groups =
    (recursiveUpdate (builtins.fromJSON (builtins.readFile ./groups.json)) {
      g_public_v4_hostnames = lib.mapAttrsToList (k: v: "${k}.net.leona.is") (lib.filterAttrs (k: v: v.meta.hasPublicIpv4) hosts);
      g_public_v6_hostnames = lib.mapAttrsToList (k: v: "${k}.net.leona.is") (lib.filterAttrs (k: v: v.meta.hasPublicIpv6) hosts);
      monitoring = {
        g_hostnames = builtins.map (host: "${host}.wg.net.leona.is") groups.monitoring.hosts;
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
            }) (builtins.filter (x: x.services.wireguard.interfaces ? ${ifName})
              (getHosts
                (builtins.filter (x: x != currentHost) groups.wireguard.hosts)
                hosts)));

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
  nyan.g_assignements = builtins.mapAttrs (hostnname: config:
    config.nyan
  ) (filterAttrs (
    hostname: config: config ? nyan
  ) hosts);
  services = {
    dns-int.g_dns_records = mapAttrs' (hostname: config:
      nameValuePair "${hostname}.wg.net" {
        AAAA = [ config.meta.intIpv6 ];
      }) hosts // mapAttrs' (hostname: config:
      nameValuePair "${hostname}.nyan.net" {
        A = [ config.nyan.legacyAddress ];
      }) (filterAttrs (
        hostname: config: config ? nyan
      ) hosts);
  };
}
