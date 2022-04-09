{ config, ... }:

{
  l.sops.secrets."hosts/turingmachine/wireguard_wg-clients_privatekey".owner = "systemd-network";
  l.sops.secrets."hosts/turingmachine/wireguard_wg-public_privatekey".owner = "systemd-network";
  systemd.network.netdevs = {
    "30-wg-clients" = {
      netdevConfig = {
        Kind = "wireguard";
        Name = "wg-clients";
      };
      wireguardConfig = {
        PrivateKeyFile = config.sops.secrets."hosts/turingmachine/wireguard_wg-clients_privatekey".path;
      };
      wireguardPeers = [{
        wireguardPeerConfig = {
          AllowedIPs = [ "10.151.0.0/16" "fd8f:d15b:9f40::/48" ];
          PublicKey = "ULV9Pt0i4WHZ1b1BNS8vBa2e9Lx1MR3DWF8sW8HM1Wo=";
          Endpoint = "wg.net.leona.is:51442";
        };
      }];
    };
    "30-wg-public" = {
      netdevConfig = {
        Kind = "wireguard";
        Name = "wg-public";
      };
      wireguardConfig = {
        PrivateKeyFile = config.sops.secrets."hosts/turingmachine/wireguard_wg-public_privatekey".path;
      };
      wireguardPeers = [{
        wireguardPeerConfig = {
          AllowedIPs = [ "0.0.0.0/0" "::/0" ];
          PublicKey = "aY/jNzJUjtohM2yoYSsDRnZyRppcxFHyw9AiDIV7cxQ=";
          Endpoint = "wg.net.leona.is:51440";
        };
      }];
    };
  };
  systemd.network.networks = {
    "30-wg-clients" = {
      name = "wg-clients";
      linkConfig = {
        RequiredForOnline = "no";
        ActivationPolicy = "manual";
      };
      address = [
        "10.151.9.2/32"
        "fd8f:d15b:9f40:0901::1/72"
      ];
      routes = [
        { routeConfig.Destination = "10.151.0.0/16"; }
        { routeConfig.Destination = "fd8f:d15b:9f40::/48"; }
      ];
    };
    "30-wg-public" = {
      name = "wg-public";
      linkConfig = {
        RequiredForOnline = "no";
        ActivationPolicy = "manual";
      };
      address = [
        "195.39.247.148/32"
        "2a0f:4ac0:1e0:100::1/64"
      ];
      routes = [
        { routeConfig.Destination = "0.0.0.0/0"; }
        { routeConfig.Destination = "::/0"; }
      ];
    };
  };
}
