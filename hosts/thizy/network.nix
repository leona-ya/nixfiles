{ config, pkgs, ... }:

{
  l.sops.secrets."hosts/thizy/wireguard_wg-clients_privatekey".owner = "systemd-network";
  networking.useDHCP = false;
  networking.hostName = "thizy";
  networking.domain = "net.leona.is";

  networking.wireless.iwd = {
    enable = true;
    settings = {
      General = {
        AddressRandomization = "network";
      };
    };
  };
  systemd.network = {
    netdevs."30-wg-clients" = {
      netdevConfig = {
        Kind = "wireguard";
        Name = "wg-clients";
      };
      wireguardConfig = {
        PrivateKeyFile = config.sops.secrets."hosts/thizy/wireguard_wg-clients_privatekey".path;
      };
      wireguardPeers = [
        {
          AllowedIPs = [
            "10.151.0.0/16"
            "fd8f:d15b:9f40::/48"
          ];
          PublicKey = "ULV9Pt0i4WHZ1b1BNS8vBa2e9Lx1MR3DWF8sW8HM1Wo=";
          Endpoint = "wg.net.leona.is:4500";
        }
      ];
    };
    networks."99-ethernet-default-dhcp" = {
      matchConfig = {
        Type = "ether";
        Kind = "!*";
      };
      DHCP = "yes";
      networkConfig.IPv6PrivacyExtensions = "kernel";
    };
    networks."10-wlan0" = {
      DHCP = "yes";
      matchConfig.Name = "wlan0";
      networkConfig.IPv6PrivacyExtensions = "kernel";
    };
    networks."30-wg-clients" = {
      name = "wg-clients";
      linkConfig = {
        RequiredForOnline = "no";
        ActivationPolicy = "manual";
      };
      address = [
        "10.151.9.7/32"
        "fd8f:d15b:9f40:0901:300::1/72"
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
  };
}
