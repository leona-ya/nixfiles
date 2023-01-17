{ config, lib, ...}: 

let
  hosthelper = import ../../hosts { inherit lib config; };
in {
  l.sops.secrets."hosts/ladon/wireguard_wg-server_privatekey".owner = "systemd-network";
  networking.firewall.allowedUDPPorts = [ 51441 ];
  networking.hostName = "ladon";
  networking.domain = "net.leona.is";
  systemd.network = {
    links = {
      "10-eth0" = {
        matchConfig.MACAddress = "96:00:01:d1:43:9a";
        linkConfig.Name = "eth0";
      };
      "10-eth-nat" = {
        matchConfig.MACAddress = "86:00:00:32:72:6e";
        linkConfig.Name = "eth-nat";
      };
    };
    netdevs = hosthelper.groups.wireguard.g_systemd_network_netdevconfig;
    networks = {
      "10-eth0" = {
        matchConfig = {
          Name = "eth0";
        };
        dns = [ "2001:4860:4860::8888" ];
        address = [
          "2a01:4f8:1c17:e4ce::1/64"
        ];
        routes = [
          { routeConfig = { Destination = "::/0"; Gateway = "fe80::1"; GatewayOnLink = true; }; }
        ];
      };
      "10-eth-nat" = {
        matchConfig.Name = "eth-nat";
        address = [ "10.62.41.4/32" ];
        routes = [
          { routeConfig = { Destination = "0.0.0.0/0"; Gateway = "10.62.41.1"; GatewayOnLink = true; }; }
        ];
      };
    } // hosthelper.groups.wireguard.g_systemd_network_networkconfig;
  };

  networking.useHostResolvConf = false;
}