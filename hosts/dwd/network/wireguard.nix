{ lib, config, ... }:

let
  hosthelper = import ../../../hosts/helper.nix { inherit lib config; };
in
{
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
        AllowedIPs = [
          "0.0.0.0/0"
          "::/0"
        ];
        PublicKey = "f+fi4A3eZ2WWrIQc+OQugriDj1FPASBXdIW39TW5aF0=";
        Endpoint = "bij.net.leona.is:51440";
        PersistentKeepalive = 21;
      }];
    };
  };
  systemd.network.networks = hosthelper.groups.wireguard.g_systemd_network_networkconfig // {
    "30-wg-public" = {
      name = "wg-public";
      linkConfig = { RequiredForOnline = "yes"; };
      address = [ "195.39.247.151/32" "2a0f:4ac0:1e0:20::1/60" ];
      routingPolicyRules = [
        {
          Family = "ipv4";
          From = "195.39.247.151/32";
          SuppressPrefixLength = 0;
          Priority = 100;
        }
        {
          Family = "ipv4";
          Table = 30;
          From = "195.39.247.151/32";
        }
        {
          Family = "ipv6";
          From = "2a0f:4ac0:1e0:20::1/60";
          SuppressPrefixLength = 0;
          Priority = 100;
        }
        {
          Family = "ipv6";
          Table = 30;
          From = "2a0f:4ac0:1e0:20::1/60";
          Priority = 200;
        }
      ];
      routes = [
        {
          Destination = "::/0";
          Table = 30;
        }
        {
          Destination = "0.0.0.0/0";
          Table = 30;
        }
      ];
    };
  };
}
