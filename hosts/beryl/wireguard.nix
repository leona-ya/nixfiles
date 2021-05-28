{ config, ... }:

{
  em0lar.secrets."wireguard_haku_privatekey".owner = "systemd-network";
  systemd.network = {
    netdevs."30-wg-haku" = {
      netdevConfig = {
        Kind = "wireguard";
        Name = "wg-haku";
      };
      wireguardConfig = {
        PrivateKeyFile = config.em0lar.secrets."wireguard_haku_privatekey".path;
      };
      wireguardPeers = [{
        wireguardPeerConfig = {
          AllowedIPs = [
            "0.0.0.0/0"
          ];
          PublicKey = "aY/jNzJUjtohM2yoYSsDRnZyRppcxFHyw9AiDIV7cxQ=";
          Endpoint = "wg-sternpunkt.em0lar.dev:51440";
          PersistentKeepalive = 21;
        };
      }];
    };
    networks."30-wg-haku" = {
      name = "wg-haku";
      linkConfig = { RequiredForOnline = "yes"; };
      address = [
        "195.39.247.145/32"
      ];
      routes = [ { routeConfig.Destination = "0.0.0.0/0"; } ];
      dns = [
        "1.1.1.1"
        "1.0.0.1"
        "8.8.8.8"
        "8.8.4.4"
      ];
    };
    netdevs."30-wg-rechaku" = {
      netdevConfig = {
        Kind = "wireguard";
        Name = "wg-rechaku";
      };
      wireguardConfig = {
        PrivateKeyFile = config.em0lar.secrets."wireguard_haku_privatekey".path;
      };
      wireguardPeers = [{
        wireguardPeerConfig = {
          AllowedIPs = [
            "::/0"
          ];
          PublicKey = "aY/jNzJUjtohM2yoYSsDRnZyRppcxFHyw9AiDIV7cxQ=";
          Endpoint = "rechaku.het.fks.de.em0lar.dev:51440";
          PersistentKeepalive = 21;
        };
      }];
    };
    networks."30-wg-rechaku" = {
      name = "wg-rechaku";
      linkConfig = { RequiredForOnline = "yes"; };
      address = [
        "2a01:4f8:c17:235a:1000::3/128"
      ];
      routes = [
        { routeConfig.Destination = "::/0"; }
        {
          routeConfig = {
            Destination = "::/0";
            Table = 30;
          };
        }
      ];
      routingPolicyRules = [
        {
          routingPolicyRuleConfig = {
            Family = "ipv6";
            Table = 30;
            From = "2a01:4f8:c17:235a::1/64";
          };
        }
      ];
      dns = [
        "2606:4700:4700::1111"
        "2606:4700:4700::1001"
        "2001:4860:4860::8888"
        "2001:4860:4860::8844"
      ];
    };
    networks."10-eth0".routes = [
      {
        routeConfig = {
          Destination = "195.39.247.188/32";
          Gateway = "_dhcp4";
        };
      }
      {
        routeConfig = {
          Destination = "2a0f:4ac0:0:1::d25/128";
          Gateway = "_ipv6ra";
        };
      }
      {
        routeConfig = {
          Destination = "49.12.7.88/32";
          Gateway = "_dhcp4";
        };
      }
      {
        routeConfig = {
          Destination = "2a01:4f8:c17:235a::1/128";
          Gateway = "_ipv6ra";
        };
      }
    ];
  };
}
