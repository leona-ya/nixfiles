{ lib, config, currentHost ? config.networking.hostName, ... }:
let
  getHosts = hostnames: hosts:
    builtins.map (hostname: lib.getAttrFromPath [ hostname ] hosts) hostnames;
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
              routed = [ "fd8f:d15b:9f40::/53" "10.151.0.0/21" ];
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
  };
  groups =
    (lib.recursiveUpdate (builtins.fromJSON (builtins.readFile ./groups.json)) {
      monitoring = {
        g_ips = builtins.map (host: "[${host.meta.intIpv6}]")
          (getHosts groups.monitoring.hosts hosts);
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
                Endpoint = lib.mkIf (ifaceConfig ? hostname)
                  "${ifaceConfig.hostname}:${toString groupConfig.port}";
                PublicKey = ifaceConfig.publicKey;
                PersistentKeepalive = 21;
              };
            }) (builtins.filter (x: x.services.wireguard.interfaces ? ${ifName})
              (getHosts
                (builtins.filter (x: x != currentHost) groups.wireguard.hosts)
                hosts)));

        g_systemd_network_netdevconfig = lib.mapAttrs' (ifName: value:
          let
            ifaceConfig =
              hosts.${currentHost}.services.wireguard.interfaces.${ifName};
          in lib.nameValuePair "30-wg-${ifName}" {
            netdevConfig = {
              Kind = "wireguard";
              Name = "wg-${ifName}";
            };
            wireguardConfig = {
              ListenPort = groups.wireguard.interfaces.${ifName}.port;
              PrivateKeyFile =
                config.em0lar.secrets."wireguard_wg-${ifName}_privatekey".path;
            };
            wireguardPeers =
              groups.wireguard.g_currenthost_generate_peers ifName
              ++ (if ifaceConfig ? extraWireguardPeers then
                ifaceConfig.extraWireguardPeers
              else
                [ ]);
          }) hosts.${currentHost}.services.wireguard.interfaces;
        g_systemd_network_networkconfig = lib.mapAttrs' (ifName: value:
          let
            ifaceConfig =
              hosts.${currentHost}.services.wireguard.interfaces.${ifName};
            groupConfig = groups.wireguard.interfaces.${ifName};
          in lib.nameValuePair "30-wg-${ifName}" {
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
}
