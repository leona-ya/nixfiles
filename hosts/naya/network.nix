{ config, lib, ... }:

let
  hosthelper = import ../../hosts/helper.nix { inherit lib config; };
in
{
  networking.firewall.allowedUDPPorts = [ 4500 51440 51441 ];

  networking.hostName = "naya";
  networking.domain = "net.leona.is";
  systemd.network = {
    links = {
      "10-eth0" = {
        matchConfig.MACAddress = "96:00:03:c0:02:b3";
        linkConfig.Name = "eth0";
      };
      "10-eth-nat" = {
        matchConfig.MACAddress = "86:00:00:f4:73:1d";
        linkConfig.Name = "eth-nat";
      };
    };
   # netdevs = hosthelper.groups.wireguard.g_systemd_network_netdevconfig;
    networks = {
      "10-eth0" = {
        DHCP = "yes";
        matchConfig = {
          Name = "eth0";
        };
        address = [
          "2a01:4f8:1c17:51ec::1/64"
        ];
        dns = [ "2001:4860:4860::8888" ];
        routes = [
          { Destination = "::/0"; Gateway = "fe80::1"; GatewayOnLink = true; }
        ];
      };
      "10-eth-nat" = {
        matchConfig.Name = "eth-nat";
        address = [ "10.62.41.4/32" ];
        routes = [
          { Destination = "0.0.0.0/0"; Gateway = "10.62.41.1"; GatewayOnLink = true; }
        ];
      };
    };
#    } // hosthelper.groups.wireguard.g_systemd_network_networkconfig;
  };

  networking.useHostResolvConf = false;
}

