{ config, ... }:

{
  em0lar.secrets."wireguard_wg-clients_privatekey" = {
    owner = "systemd-network";
    group-name = "systemd-network";
  };
  systemd.network.netdevs."30-wg-clients" = {
    netdevConfig = {
      Kind = "wireguard";
      Name = "wg-clients";
    };
    wireguardConfig = {
      PrivateKeyFile = config.em0lar.secrets."wireguard_wg-clients_privatekey".path;
    };
    wireguardPeers = [{
      wireguardPeerConfig = {
        AllowedIPs = [ "10.151.0.0/16" "fd8f:d15b:9f40::/48" ];
        PublicKey = "ULV9Pt0i4WHZ1b1BNS8vBa2e9Lx1MR3DWF8sW8HM1Wo=";
        Endpoint = "wg.net.em0lar.dev:51442";
      };
    }];
  };
  systemd.network.networks."30-wg-clients" = {
    name = "wg-clients";
    linkConfig = { RequiredForOnline = "no"; };
    address = [
      "10.151.9.2/32"
      "fd8f:d15b:9f40:0901::1/72"
    ];
    routes = [
      #{ routeConfig.Destination = "10.151.0.0/16"; }
      #{ routeConfig.Destination = "fd8f:d15b:9f40::/48"; }
    ];
  };
}
