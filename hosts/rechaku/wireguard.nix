
{ config, ... }:

{
  networking.firewall.allowedUDPPorts = [
    51440
    51441
    51442
  ];
  em0lar.secrets = {
    "wireguard_wg-public_privatekey".owner = "systemd-network";
  };
  em0lar.nftables.extraForward = ''
    ct state invalid drop
    ct state established,related accept
    iifname wg-public ct state new accept
    oifname wg-public ct state new accept
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
              "2a01:4f8:c010:9e88:1000::2/128"
            ];
            PublicKey = "CnswutrDvUJdDIsopjkvjO/SiOrKdx3ob0jvDf0LLFI=";
            PersistentKeepalive = 21;
          };
        }
        { # beryl
          wireguardPeerConfig = {
            AllowedIPs = [
              "2a01:4f8:c010:9e88:1000::3/128"
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
        "2a01:4f8:c010:9e88:1000::1/128"
      ];
      networkConfig = {
        IPForward = true;
      };
      routes = [
        { routeConfig.Destination = "2a01:4f8:c010:9e88:1000::/68"; }
      ];
    };
  };
}
