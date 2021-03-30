{ config, ... }:

{
  boot.extraModulePackages = [ config.boot.kernelPackages.wireguard ];
  em0lar.secrets."wireguard_clients_privatekey" = {
    owner = "systemd-network";
    group-name = "systemd-network";
  };
  systemd.network.netdevs."30-wg-clients" = {
    netdevConfig = {
      Kind = "wireguard";
      Name = "wg-clients";
    };
    wireguardConfig = {
      PrivateKeyFile = config.em0lar.secrets."wireguard_clients_privatekey".path;
    };
    wireguardPeers = [{
      wireguardPeerConfig = {
        AllowedIPs = [ "10.151.0.0/16" "fd8f:d15b:9f40:0900::/48" ];
        PublicKey = "4W0KV00IBGmVoxzJ1R5bm6Aa/VazMRHZY8Y8uo5zOCU=";
        Endpoint = "janus.ion.rhr.de.em0lar.dev:40000";
      };
    }];
  };
  systemd.network.networks."30-wg-clients" = {
    name = "wg-clients";
    linkConfig = { RequiredForOnline = "no"; };
    address = [ "10.151.9.2/32" "fd8f:d15b:9f40:0900:1::1/128" ];
    routes = [
      #{ routeConfig.Destination = "10.151.0.0/16"; }
      #{ routeConfig.Destination = "fd8f:d15b:9f40:0900::/48"; }
    ];
  };
}
