{ config, ... }:

{
  l.sops.secrets."hosts/turingmachine/wireguard_wg-clients_privatekey".owner = "systemd-network";
  systemd.network.netdevs = {
    "30-wg-clients" = {
      netdevConfig = {
        Kind = "wireguard";
        Name = "wg-clients";
      };
      wireguardConfig = {
        PrivateKeyFile = config.sops.secrets."hosts/turingmachine/wireguard_wg-clients_privatekey".path;
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
  };
  systemd.network.networks = {
    "30-wg-clients" = {
      name = "wg-clients";
      linkConfig = {
        RequiredForOnline = "no";
        ActivationPolicy = "manual";
      };
      address = [
        "10.151.9.8/32"
        "fd8f:d15b:9f40:0901:400::1/72"
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
