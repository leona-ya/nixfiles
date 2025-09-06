{ config, ... }:

{
  l.sops.secrets."hosts/kupe/wireguard_wg-public_privatekey".owner = "systemd-network";
  systemd.network = {
    netdevs."30-wg-haku" = {
      netdevConfig = {
        Kind = "wireguard";
        Name = "wg-haku";
      };
      wireguardConfig = {
        PrivateKeyFile = config.sops.secrets."hosts/kupe/wireguard_wg-public_privatekey".path;
      };
      wireguardPeers = [
        {
          AllowedIPs = [
            "0.0.0.0/0"
          ];
          PublicKey = "aY/jNzJUjtohM2yoYSsDRnZyRppcxFHyw9AiDIV7cxQ=";
          Endpoint = "haku.net.leona.is:51440";
          PersistentKeepalive = 21;
        }
      ];
    };
    networks."30-wg-haku" = {
      name = "wg-haku";
      linkConfig = {
        RequiredForOnline = "yes";
      };
      address = [
        "195.39.247.146/32"
      ];
      routes = [
        { Destination = "0.0.0.0/0"; }
      ];
    };
    networks."10-eth0".routes = [
      {
        Destination = "195.39.247.188/32";
        Gateway = "_dhcp4";
      }
    ];
  };
}
