
{ config, ... }:

{
  em0lar.secrets."wireguard_wg-server_privatekey".owner = "systemd-network";
  networking.firewall.allowedUDPPorts = [ 51441 ];

  systemd.network.netdevs."30-wg-server" = {
    netdevConfig = {
      Kind = "wireguard";
      Name = "wg-server";
    };
    wireguardConfig = {
      PrivateKeyFile = config.em0lar.secrets."wireguard_wg-server_privatekey".path;
      ListenPort = 51441;
    };
    wireguardPeers = [
      {
        wireguardPeerConfig = {
          AllowedIPs = [ "fd8f:d15b:9f40:0c20::1/72" ];
          PublicKey = "duhZn+JOja6bILYxs6D2dKQk7GhmflSsqr+AMOVqJkg=";
          Endpoint = "naiad.net.em0lar.dev:51441";
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
  systemd.network.networks."30-wg-server" = {
    name = "wg-server";
    linkConfig = { RequiredForOnline = "yes"; };
    address = [ "fd8f:d15b:9f40:0c21::1/72" ];
    routes = [
      { routeConfig.Destination = "fd8f:d15b:9f40::/48"; }
    ];
  };
}
