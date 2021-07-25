
{ config, ... }:

{
  em0lar.secrets."wireguard_server_privatekey".owner = "systemd-network";
  em0lar.secrets."wireguard_wg-public_privatekey".owner = "systemd-network";
  networking.firewall.allowedUDPPorts = [ 51441 ];

  systemd.network = {
    netdevs."30-wg-server" = {
      netdevConfig = {
        Kind = "wireguard";
        Name = "wg-server";
      };
      wireguardConfig = {
        ListenPort = 51441;
        PrivateKeyFile = config.em0lar.secrets."wireguard_server_privatekey".path;
      };
      wireguardPeers = [
        {
          wireguardPeerConfig = {
            AllowedIPs = [ "fd8f:d15b:9f40:0c21::1/72" ];
            PublicKey = "xEgZUGdhPkIAZYmDszEUHm86zStsJMF3lowGIkjQE1k=";
            Endpoint = "myron.net.em0lar.dev:51441";
          };
        }
        { # atlas
          wireguardPeerConfig = {
            AllowedIPs = [
              "fd8f:d15b:9f40::/53"
            ];
            PublicKey = "8Jzx9hklD8g6colimGybv9kpC2q0oTIgrISGhLd0QEM=";
            PersistentKeepalive = 21;
          };
        }
        {
          wireguardPeerConfig = {
            AllowedIPs = [ "fd8f:d15b:9f40:0900::/48" ];
            PublicKey = "376YjLMEUFHWFE5Xkn3qRyIQ/kAHzM4DhvIcC5boCQ8=";
            Endpoint = "wg.net.em0lar.dev:51441";
          };
        }
      ];
    };
    networks."30-wg-server" = {
      name = "wg-server";
      linkConfig = { RequiredForOnline = "yes"; };
      address = [ "fd8f:d15b:9f40:0c20::1/72" ];
      routes = [
        { routeConfig.Destination = "fd8f:d15b:9f40::/48"; }
      ];
    };


    ##################
    # Backup Wireguard
    ##################
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
              "2a03:4000:f:85f:1000::1/72"
            ];
            PublicKey = "CnswutrDvUJdDIsopjkvjO/SiOrKdx3ob0jvDf0LLFI=";
            PersistentKeepalive = 21;
          };
        }
        { # beryl
          wireguardPeerConfig = {
            AllowedIPs = [
              "2a03:4000:f:85f:1100::1/72"
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
      networkConfig = {
        IPForward = true;
      };
      routes = [
        { routeConfig.Destination = "2a03:4000:f:85f:1000::/68"; }
      ];
    };
  };
}
