{ lib, config, currentHost ? config.networking.hostName, ... }:
with lib;
let
  getHosts = hostnames: hosts:
    builtins.map (hostname: getAttrFromPath [ hostname ] hosts) hostnames;
in rec {
  hosts = {
    adonis = {
      meta = { intIpv6 = "fd8f:d15b:9f40:0c10::1"; };
      services = {
        wireguard = {
          interfaces = {
            "server" = {
              ips = [ "${hosts.dwd.meta.intIpv6}/72" ];
              publicKey = "KVB9uOM1n3VgdhjWzLkXLygMPzg/n+MORLba80EE7Xc=";
              routed = [ "fd8f:d15b:9f40:0c10::1/72" ];
              hostname = "adonis.net.em0lar.dev";
            };
          };
        };
      };
    };
    beryl = { meta = { intIpv6 = "fd8f:d15b:9f40:11:8079:3aff:fe35:9ddc"; }; };
    dwd = {
      meta = { intIpv6 = "fd8f:d15b:9f40::1"; };
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
    foros = { meta = { intIpv6 = "fd8f:d15b:9f40:11:2c5a:56ff:fe4f:e4c4"; }; };
    kupe = {
      meta = {
        intIpv6 = "fd8f:d15b:9f40:c31:5054:ff:fec0:8539";
      };
      nyo = {
        mac = "52:54:00:c0:85:39";
        duid = "00:02:00:00:ab:11:9b:68:58:51:30:82:69:52";
        legacyAddress = "10.151.20.10";
        address = "2a01:4f8:212:ad7:1000::f28";
      };
    };
    haku = {
      meta = { intIpv6 = "fd8f:d15b:9f40:0c00::1"; };
      services = {
        wireguard = {
          interfaces = {
            "server" = {
              ips = [ "${hosts.haku.meta.intIpv6}/72" ];
              publicKey = "376YjLMEUFHWFE5Xkn3qRyIQ/kAHzM4DhvIcC5boCQ8=";
              routed = [ "fd8f:d15b:9f40::/48" "10.151.0.0/16" ];
              hostname = "haku.net.em0lar.dev";
              interfaceRoutes = [
                { routeConfig.Destination = "10.151.0.0/21"; }
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
                      [ "195.39.247.144/32" "2a0f:4ac0:1e0:100::/64" ];
                    PublicKey = "CnswutrDvUJdDIsopjkvjO/SiOrKdx3ob0jvDf0LLFI=";
                    PersistentKeepalive = 21;
                  };
                }
                { # beryl
                  wireguardPeerConfig = {
                    AllowedIPs =
                      [ "195.39.247.145/32" "2a0f:4ac0:1e0:101::/64" ];
                    PublicKey = "DBfzjdPqk5Ee8OYsqNy2LoM7kvbh8ppmK836jlGz43s=";
                    PersistentKeepalive = 21;
                  };
                }
              ];
            };
          };
        };
      };
    };
    ladon = { meta = { intIpv6 = "fd8f:d15b:9f40:11:6cf2:ecff:fe90:8c3c"; }; };
    myron = {
      meta = { intIpv6 = "fd8f:d15b:9f40:0c21::1"; };
      services = {
        wireguard = {
          interfaces = {
            "server" = {
              ips = [ "${hosts.myron.meta.intIpv6}/72" ];
              publicKey = "xEgZUGdhPkIAZYmDszEUHm86zStsJMF3lowGIkjQE1k=";
              routed = [ "fd8f:d15b:9f40:0c21::1/72" ];
              hostname = "myron.net.em0lar.dev";
            };
          };
        };
      };
    };
    naiad = {
      meta = { intIpv6 = "fd8f:d15b:9f40:0c20::1"; };
      services = {
        wireguard = {
          interfaces = {
            "server" = {
              ips = [ "${hosts.naiad.meta.intIpv6}/72" ];
              publicKey = "duhZn+JOja6bILYxs6D2dKQk7GhmflSsqr+AMOVqJkg=";
              routed = [ "fd8f:d15b:9f40:0c20::1/72" ];
              hostname = "naiad.net.em0lar.dev";
            };
          };
        };
      };
    };
    nyo = {
      meta = { intIpv6 = "fd8f:d15b:9f40:0c30::1"; };
      services = {
        wireguard = {
          interfaces = {
            "server" = {
              ips = [ "${hosts.nyo.meta.intIpv6}/60" ];
              publicKey = "AilevKAZRnvQUkJhg/R9APpYUdEbnE1g2BP+FUQwBBI=";
              routed = [ "fd8f:d15b:9f40:0c30::/60" ];
              hostname = "nyo.net.em0lar.dev";
            };
          };
        };
      };
    };
  };
  groups =
    (recursiveUpdate (builtins.fromJSON (builtins.readFile ./groups.json)) {
      monitoring = {
        g_hostnames = builtins.map (host: "${host}.wg.net.em0lar.dev") groups.monitoring.hosts;
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
  nyo.g_assignements = builtins.mapAttrs (hostnname: config:
    config.nyo
  ) (filterAttrs (
    hostname: config: config ? nyo
  ) hosts);
  services = {
    dns-int.g_dns_records = mapAttrs' (hostname: config:
      nameValuePair "${hostname}.wg.net" {
        AAAA = [ config.meta.intIpv6 ];
      }) hosts // mapAttrs' (hostname: config:
      nameValuePair "${hostname}.nyo.net" {
        A = [ config.nyo.legacyAddress ];
      }) (filterAttrs (
        hostname: config: config ? nyo
      ) hosts);
  };
}
