{ config, ... }:

{
  networking.firewall.allowedUDPPorts = [
    51440
    51441
    51442
  ];
  boot.extraModulePackages = [ config.boot.kernelPackages.wireguard ];
  em0lar.secrets = {
    "wireguard_wg-public_privatekey".owner = "systemd-network";
    "wireguard_wg-server_privatekey".owner = "systemd-network";
    "wireguard_wg-clients_privatekey".owner = "systemd-network";
  };
  em0lar.nftables.extraForward = ''
    ct state invalid drop
    ct state established,related accept
    iifname wg-public ct state new accept
    oifname wg-public ct state new accept
    iifname wg-clients oifname wg-server ct state new accept
    iifname wg-clients oifname wg-clients ct state new accept
    iifname wg-server oifname wg-clients ct state new accept
    iifname wg-server oifname wg-server ct state new accept
  '';
  systemd.network = {
    netdevs."30-wg-public" = {
      netdevConfig = {
        Kind = "wireguard";
        Name = "wg-public";
      };
      wireguardConfig = {

        ListenPort = 51440;
        PrivateKeyFile = config.em0lar.secrets."wireguard_wg-public_privatekey".path;
      };
      wireguardPeers = [
        { # foros
          wireguardPeerConfig = {
            AllowedIPs = [
              "195.39.247.144/32"
              "2a0f:4ac0:1e0:100::/64"
            ];
            PublicKey = "CnswutrDvUJdDIsopjkvjO/SiOrKdx3ob0jvDf0LLFI=";
            PersistentKeepalive = 21;
          };
        }
        { # beryl
          wireguardPeerConfig = {
            AllowedIPs = [
              "195.39.247.145/32"
              "2a0f:4ac0:1e0:101::/64"
            ];
            PublicKey = "DBfzjdPqk5Ee8OYsqNy2LoM7kvbh8ppmK836jlGz43s=";
            PersistentKeepalive = 21;
          };
        }
      ];
    };
    networks."30-wg-public" = {
      name = "wg-public";
      linkConfig = { RequiredForOnline = "no"; };
      address = [
        "2a0f:4ac0:1e0::1/128"
      ];
      networkConfig = {
        IPForward = true;
      };
      routes = [
        { routeConfig.Destination = "195.39.247.144/28"; }
        { routeConfig.Destination = "2a0f:4ac0:1e0::/48"; }
      ];
    };

    netdevs."30-wg-server" = {
      netdevConfig = {
        Kind = "wireguard";
        Name = "wg-server";
      };
      wireguardConfig = {
        ListenPort = 51441;
        PrivateKeyFile = config.em0lar.secrets."wireguard_wg-server_privatekey".path;
      };
      wireguardPeers = [
        { # atlas
          wireguardPeerConfig = {
            AllowedIPs = [
              "10.151.0.0/21"
              "fd8f:d15b:9f40::/53"
            ];
            PublicKey = "8Jzx9hklD8g6colimGybv9kpC2q0oTIgrISGhLd0QEM=";
            PersistentKeepalive = 21;
          };
        }
        { # naiad
          wireguardPeerConfig = {
            AllowedIPs = [ "fd8f:d15b:9f40:0c20::1/72" ];
            Endpoint = "naiad.ncp.nue.de.em0lar.dev:51441";
            PublicKey = "duhZn+JOja6bILYxs6D2dKQk7GhmflSsqr+AMOVqJkg=";
          };
        }
        { # myron
          wireguardPeerConfig = {
            AllowedIPs = [ "fd8f:d15b:9f40:0c21::1/72" ];
            Endpoint = "myron.het.hel.fi.em0lar.dev:51441";
            PublicKey = "xEgZUGdhPkIAZYmDszEUHm86zStsJMF3lowGIkjQE1k=";
          };
        }
      ];
    };
    networks."30-wg-server" = {
      name = "wg-server";
      linkConfig = { RequiredForOnline = "no"; };
      address = [
        "fd8f:d15b:9f40:0c00::1/72"
      ];
      networkConfig = {
        IPForward = true;
      };
      routes = [
        { routeConfig.Destination = "10.151.0.0/21"; }
        { routeConfig.Destination = "fd8f:d15b:9f40::/53"; }
        { routeConfig.Destination = "fd8f:d15b:9f40:0c00::/54"; }
      ];
    };
    
    netdevs."30-wg-clients" = {
      netdevConfig = {
        Kind = "wireguard";
        Name = "wg-clients";
      };
      wireguardConfig = {
        ListenPort = 51442;
        PrivateKeyFile = config.em0lar.secrets."wireguard_wg-clients_privatekey".path;
      };
      wireguardPeers = [
        { # turingmachine [em0lar]
          wireguardPeerConfig = {
            AllowedIPs = [
              "10.151.9.2/32"
              "fd8f:d15b:9f40:0901::1/72"
            ];
            PublicKey = "gOBDoXc3zWVpnyx81fgVKmR2un14MW+c+SM/G6F3sFY=";
          };
        }
        { # abraxas [em0lar]
          wireguardPeerConfig = {
            AllowedIPs = [
              "10.151.9.4/32"
              "fd8f:d15b:9f40:0901:100::1/72"
            ];
            PublicKey = "VZJ/wdbMd5e09nxVH2YT9FJ6sI5Wpq2HzWovjz8BVSg=";
          };
        }
        { # Luna [Dirk]
          wireguardPeerConfig = {
            AllowedIPs = [
              "10.151.9.5/32"
              "fd8f:d15b:9f40:0902::1/72"
            ];
            PublicKey = "0tlj84AXn/vVl7fAkgKsDcAcW3CN4y92sr/MKL9TBRI=";
          };
        }
        { # Luna Phone [Dirk]
          wireguardPeerConfig = {
            AllowedIPs = [
              "10.151.9.6/32"
              "fd8f:d15b:9f40:0902:100::1/72"
            ];
            PublicKey = "C8MU9Zqx740SjEYPjzIgCOlbe/D6HkDU+Vh6XwVMhFg=";
          };
        }
        { # mangan [e1mo]
          wireguardPeerConfig = {
            AllowedIPs = [
              "10.151.9.3/32"
              "fd8f:d15b:9f40:0903::1/72"
            ];
            PublicKey = "WbzIGoZFfRKoX/aBVQfkNlG9zXVHvlEhNGWV1/LBMmY=";
          };
        }
      ];
    };
    networks."30-wg-clients" = {
      name = "wg-clients";
      linkConfig = { RequiredForOnline = "no"; };
      address = [
        "10.151.9.1/32"
        "fd8f:d15b:9f40:0900::1/64"
      ];
      networkConfig = {
        IPForward = true;
      };
      routes = [
        { routeConfig.Destination = "10.151.9.0/24"; }
        { routeConfig.Destination = "fd8f:d15b:9f40:0900::/56"; }
      ];
    };
  };
}
