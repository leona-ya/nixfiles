{ lib, config, ... }:

let
  hosthelper = import ../../../hosts { inherit lib config; };
in {
  l.sops.secrets."hosts/dwd/wireguard_wg-server_privatekey".owner = "systemd-network";
  l.sops.secrets."hosts/dwd/wireguard_wg-public_privatekey".owner = "systemd-network";
  networking.firewall.allowedUDPPorts = [ 51441 ];

  systemd.network.netdevs = hosthelper.groups.wireguard.g_systemd_network_netdevconfig // {
    "30-wg-public" = {
      netdevConfig = {
        Kind = "wireguard";
        Name = "wg-public";
      };
      wireguardConfig = {
        ListenPort = 51440;
        PrivateKeyFile = config.sops.secrets."hosts/dwd/wireguard_wg-public_privatekey".path;
      };
      wireguardPeers = [{
        wireguardPeerConfig = {
          AllowedIPs = [
            "0.0.0.0/0"
            "::/0"
          ];
          PublicKey = "aY/jNzJUjtohM2yoYSsDRnZyRppcxFHyw9AiDIV7cxQ=";
          Endpoint = "wg.net.leona.is:51440";
          PersistentKeepalive = 21;
        };
      }];
    };
  };
  systemd.network.networks = hosthelper.groups.wireguard.g_systemd_network_networkconfig // {
    "30-wg-public" = {
      name = "wg-public";
      linkConfig = { RequiredForOnline = "yes"; };
      address = [ "195.39.247.151/32" "2a0f:4ac0:1e0:20::1/60" ];
#      routingPolicyRules = [
#        { routingPolicyRuleConfig = {
#          Family = "both";
#          IncomingInterface = "br-lan";
##          Table = 10;
#        }; }
#      ];
      routes = [
        { routeConfig = {
          Destination = "0.0.0.0/0";
          Metric = 512;
        }; }
        { routeConfig = {
          Destination = "::/0";
          Metric = 512;
        }; }
      ];
    };
  };
}
