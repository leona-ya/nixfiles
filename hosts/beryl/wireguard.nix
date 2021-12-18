{ config, ... }:

{
  em0lar.sops.secrets."hosts/beryl/wireguard_wg-public_privatekey".owner = "systemd-network";
  systemd.network = {
    netdevs."30-wg-haku" = {
      netdevConfig = {
        Kind = "wireguard";
        Name = "wg-haku";
      };
      wireguardConfig = {
        PrivateKeyFile = config.sops.secrets."hosts/beryl/wireguard_wg-public_privatekey".path;
      };
      wireguardPeers = [{
        wireguardPeerConfig = {
          AllowedIPs = [
            "0.0.0.0/0"
          ];
          PublicKey = "aY/jNzJUjtohM2yoYSsDRnZyRppcxFHyw9AiDIV7cxQ=";
          Endpoint = "wg.net.em0lar.dev:51440";
          PersistentKeepalive = 21;
        };
      }];
    };
    networks."30-wg-haku" = {
      name = "wg-haku";
      linkConfig = { RequiredForOnline = "yes"; };
      address = [ "195.39.247.145/32" ];
      routes = [ { routeConfig.Destination = "0.0.0.0/0"; } ];
      dns = [
        "1.1.1.1"
        "1.0.0.1"
        "8.8.8.8"
        "8.8.4.4"
      ];
    };
    networks."10-eth0".routes = [
      {
        routeConfig = {
          Destination = "195.39.247.188/32";
          Gateway = "_dhcp4";
        };
      }
    ];
  };
}
