
{ config, ... }:

{
  boot.extraModulePackages = [ config.boot.kernelPackages.wireguard ];
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
        PublicKey = "Gs1RhJtusDwCvB6ssR7MMn5uPt2ciZb/GxDHVGuw6G0=";
        Endpoint = "janus.ion.rhr.de.em0lar.dev:40001";
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
