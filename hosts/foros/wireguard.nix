{ config, ... }:

{
  em0lar.secrets."wireguard_haku_privatekey" = {
    source-path = "${../../secrets/foros/wireguard_haku_privatekey.gpg}";
    owner = "systemd-network";
    group-name = "systemd-network";
  };
  systemd.network.netdevs."30-wg-haku" = {
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
          "::/0"
        ];
        PublicKey = "aY/jNzJUjtohM2yoYSsDRnZyRppcxFHyw9AiDIV7cxQ=";
        Endpoint = "wg-sternpunkt.em0lar.dev:51440";
        PersistentKeepalive = 21;
      };
    }];
  };
  systemd.network.networks."30-wg-haku" = {
    name = "wg-haku";
    linkConfig = { RequiredForOnline = "yes"; };
    address = [
      "2a01:4f8:c17:235a:1000::2/128"
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
      "1.1.1.1"
      "1.0.0.1"
      "8.8.8.8"
      "8.8.4.4"
    ];
  };
  systemd.network.networks."10-eth0".routes = [
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
}
