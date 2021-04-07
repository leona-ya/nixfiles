
{ config, ... }:

{
  em0lar.secrets."wireguard_server_privatekey".owner = "systemd-network";

  systemd.network.netdevs."30-wg-server" = {
    netdevConfig = {
      Kind = "wireguard";
      Name = "wg-server";
    };
    wireguardConfig = {
      PrivateKeyFile = config.em0lar.secrets."wireguard_server_privatekey".path;
    };
    wireguardPeers = [{
      wireguardPeerConfig = {
        AllowedIPs = [ "fd8f:d15b:9f40:0900::/48" ];
        PublicKey = "376YjLMEUFHWFE5Xkn3qRyIQ/kAHzM4DhvIcC5boCQ8=";
        Endpoint = "wg-sternpunkt.em0lar.dev:51441";
      };
    }];
  };
  systemd.network.networks."30-wg-server" = {
    name = "wg-server";
    linkConfig = { RequiredForOnline = "yes"; };
    address = [ "fd8f:d15b:9f40:0c20::1/72" ];
    routes = [
      { routeConfig.Destination = "fd8f:d15b:9f40::/48"; }
    ];
  };
}
