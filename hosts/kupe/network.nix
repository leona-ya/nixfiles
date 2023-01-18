{ config, lib, ...}: 

let
  hosthelper = import ../../hosts { inherit lib config; };
in {
  l.sops.secrets."hosts/kupe/wireguard_wg-server_privatekey".owner = "systemd-network";
  l.sops.secrets."hosts/kupe/wireguard_wg-public_privatekey".owner = "systemd-network";
  networking.firewall.allowedUDPPorts = [ 51440 51441 ];
  networking.hostName = "kupe";
  networking.domain = "net.leona.is";
  
  systemd.network = {
    links = {
      "10-eth0" = {
        matchConfig.MACAddress = "96:00:01:d3:f7:f8";
        linkConfig.Name = "eth0";
      };
      "10-eth-nat" = {
        matchConfig.MACAddress = "86:00:00:33:10:6f";
        linkConfig.Name = "eth-nat";
      };
    };
    netdevs = {
      "30-wg-haku" = {
        netdevConfig = {
          Kind = "wireguard";
          Name = "wg-haku";
        };
        wireguardConfig = {
          PrivateKeyFile = config.sops.secrets."hosts/kupe/wireguard_wg-public_privatekey".path;
        };
        wireguardPeers = [{
          wireguardPeerConfig = {
            AllowedIPs = [
              "0.0.0.0/0"
            ];
            PublicKey = "aY/jNzJUjtohM2yoYSsDRnZyRppcxFHyw9AiDIV7cxQ=";
            Endpoint = "wg.net.leona.is:51440";
            PersistentKeepalive = 21;
          };
        }];
      };
    } // hosthelper.groups.wireguard.g_systemd_network_netdevconfig;
    networks = {
      "10-eth0" = {
        matchConfig = {
          Name = "eth0";
        };
        dns = [ "2001:4860:4860::8888" ];
        address = [
          "2a01:4f8:1c1c:f0b::1/64"
        ];
        routes = [
          { routeConfig = { Destination = "::/0"; Gateway = "fe80::1"; GatewayOnLink = true; }; }
        ];
      };
      "10-eth-nat" = {
        matchConfig.Name = "eth-nat";
        address = [ "10.62.41.5/32" ];
        routes = [
          { routeConfig = { Destination = "10.62.41.0/24"; Gateway = "10.62.41.1"; GatewayOnLink = true; }; }
        ];
      };
      "30-wg-haku" = {
        name = "wg-haku";
        linkConfig = { RequiredForOnline = "yes"; };
        address = [
          "195.39.247.146/32"
        ];
        routes = [
          { routeConfig.Destination = "0.0.0.0/0"; }
        ];
      };
    } // hosthelper.groups.wireguard.g_systemd_network_networkconfig;
  };
  networking.useHostResolvConf = false;
}