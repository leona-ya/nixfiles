{ config, ... }:

{
  l.sops.secrets."hosts/turingmachine/wireguard_wg-clients_privatekey".owner = "systemd-network";
  l.sops.secrets."hosts/turingmachine/wireguard_wg-public_privatekey".owner = "systemd-network";
  l.sops.secrets."hosts/turingmachine/wireguard_wg-fdg_privatekey".owner = "systemd-network";
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
        AllowedIPs = [ "10.151.0.0/16" "fd8f:d15b:9f40::/48" ];
        PublicKey = "ULV9Pt0i4WHZ1b1BNS8vBa2e9Lx1MR3DWF8sW8HM1Wo=";
        Endpoint = "[2a01:4f8:c010:1098::1]:4500";
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
        AllowedIPs = [ "10.151.0.0/16" "fd8f:d15b:9f40::/48" ];
        PublicKey = "ULV9Pt0i4WHZ1b1BNS8vBa2e9Lx1MR3DWF8sW8HM1Wo=";
        Endpoint = "wg.net.leona.is:4500";
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
        AllowedIPs = [ "0.0.0.0/0" "::/0" ];
        PublicKey = "f+fi4A3eZ2WWrIQc+OQugriDj1FPASBXdIW39TW5aF0=";
        Endpoint = "wg.net.leona.is:51440";
      }];
    };
    "30-wg-fdg" = {
      netdevConfig = {
        Kind = "wireguard";
        Name = "wg-fdg";
      };
      wireguardConfig = {
        PrivateKeyFile = config.sops.secrets."hosts/turingmachine/wireguard_wg-fdg_privatekey".path;
      };
      wireguardPeers = [{
        AllowedIPs = [ "fd59:974e:6ee8::/64" ];
        PublicKey = "79NbBslDrdK5fllB4+6wA9mUV7sVQCtAaPsojW0JJ0U=";
        Endpoint = "martian.infra.fahrplandatengarten.de:40000";
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
        { Destination = "10.151.0.0/16"; }
        { Destination = "fd8f:d15b:9f40::/48"; }
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
        { Destination = "10.151.0.0/16"; }
        { Destination = "fd8f:d15b:9f40::/48"; }
      ];
      dns = [
        "10.151.9.1"
        "fd8f:d15b:9f40:900::1"
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
        { Destination = "0.0.0.0/0"; }
        { Destination = "::/0"; }
      ];
    };
    "30-wg-fdg" = {
      name = "wg-fdg";
      linkConfig = {
        RequiredForOnline = "no";
        ActivationPolicy = "manual";
      };
      address = [
        "fd59:974e:6ee8:1000::1/64"
      ];
      routes = [
        { Destination = "fd59:974e:6ee8::/48"; }
      ];
    };
  };
}
