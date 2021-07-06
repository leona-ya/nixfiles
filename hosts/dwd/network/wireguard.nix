
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
    wireguardPeers = [{
      wireguardPeerConfig = {
        AllowedIPs = [
          "10.151.9.0/24"
          "10.151.16.0/24"
          "fd8f:d15b:9f40:0900::/56"
          "fd8f:d15b:9f40:0c00::/54"
        ];
        PublicKey = "376YjLMEUFHWFE5Xkn3qRyIQ/kAHzM4DhvIcC5boCQ8=";
        Endpoint = "wg-sternpunkt.em0lar.dev:51441";
        PersistentKeepalive = 21;
      };
    }];
  };
  systemd.network.networks."30-wg-server" = {
    name = "wg-server";
    linkConfig = { RequiredForOnline = "yes"; };
    address = [
      "10.151.12.128/32"
      "fd8f:d15b:9f40::1/56"
    ];
    routes = [
      { routeConfig.Destination = "10.151.9.0/24"; }
      { routeConfig.Destination = "10.151.16.0/24"; }
      { routeConfig.Destination = "fd8f:d15b:9f40:0900::/56"; }
      { routeConfig.Destination = "fd8f:d15b:9f40:0c00::/54"; }
    ];
  };
}
