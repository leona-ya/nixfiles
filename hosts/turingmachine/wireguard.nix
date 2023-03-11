{ config, ... }:

{
  l.sops.secrets."hosts/turingmachine/wireguard_wg-clients_privatekey".owner = "systemd-network";
  l.sops.secrets."hosts/turingmachine/wireguard_wg-public_privatekey".owner = "systemd-network";
  l.sops.secrets."hosts/turingmachine/wireguard_wg-public-bkp_privatekey".owner = "systemd-network";
  systemd.network.netdevs = {
    "30-wg-clients-6" = {
      netdevConfig = {
        Kind = "wireguard";
        Name = "wg-clients-6";
      };
      wireguardConfig = {
        PrivateKeyFile = config.sops.secrets."hosts/turingmachine/wireguard_wg-clients_privatekey".path;
      };
      wireguardPeers = [{
        wireguardPeerConfig = {
          AllowedIPs = [ "10.151.0.0/16" "fd8f:d15b:9f40::/48" ];
          PublicKey = "ULV9Pt0i4WHZ1b1BNS8vBa2e9Lx1MR3DWF8sW8HM1Wo=";
          Endpoint = "[2a01:4f8:c010:1098::1]:4500";
        };
      }];
    };
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
          Endpoint = "wg.net.leona.is:4500";
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
    "30-wg-public-bkp" = {
      netdevConfig = {
        Kind = "wireguard";
        Name = "wg-public-bkp";
      };
      wireguardConfig = {
        PrivateKeyFile = config.sops.secrets."hosts/turingmachine/wireguard_wg-public-bkp_privatekey".path;
      };
      wireguardPeers = [{
        wireguardPeerConfig = {
          AllowedIPs = [ "::/0" ];
          PublicKey = "aY/jNzJUjtohM2yoYSsDRnZyRppcxFHyw9AiDIV7cxQ=";
          Endpoint = "wg.net.leona.is:51440";
        };
      }];
    };

  };
  systemd.network.networks = {
    "30-wg-clients-6" = {
      name = "wg-clients-6";
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
      dns = [
        "10.151.9.1"
#        "1.0.0.1"
        "fd8f:d15b:9f40:900::1"
#        "2606:4700:4700::1001"
      ];
    };
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
      dns = [
        "10.151.9.1"
#        "1.0.0.1"
        "fd8f:d15b:9f40:900::1"
#        "2606:4700:4700::1001"
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
    "30-wg-public-bkp" = {
      name = "wg-public-bkp";
      linkConfig = {
        RequiredForOnline = "no";
        ActivationPolicy = "manual";
      };
      address = [
        "2a01:4f8:242:155f:5100::1/72"
      ];
      routes = [
        { routeConfig.Destination = "::/0"; }
      ];
    };
  };
}
