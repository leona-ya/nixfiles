{ lib, config, ... }: let
  hosthelper = import ../../hosts { inherit lib config; };
in {
  l.sops.secrets."hosts/enari/wireguard_wg-fdg_privatekey".owner = "systemd-network";
  l.sops.secrets."hosts/enari/wireguard_wg-server_privatekey".owner = "systemd-network";
  networking.hostName = "enari";
  networking.domain = "net.leona.is";
  networking.firewall.allowedUDPPorts = [ 51441 ];
  systemd.network = {
    links."10-eth0" = {
      matchConfig.MACAddress = "02:01:af:69:b7:ea";
      linkConfig.Name = "eth0";
    };
    networks = {
      "10-eth0" = {
        DHCP = "yes";
        matchConfig = {
          Name = "eth0";
        };
        networkConfig.Tunnel="he6";
      };

      # aaaa why? :(
      "he6" = {
        matchConfig.Name = "he6";
        address = [
          "2001:470:1f0a:1111::2/64"
          "2001:470:1f0b:1112::1/64"
        ];
        gateway = [
          "2001:470:1f0a:1111::1"
        ];
      };
      "30-wg-fdg" = {
        name = "wg-fdg";
        address = [
          "fd59:974e:6ee8:1001::1/64"
        ];
        routes = [
          { routeConfig.Destination = "fd59:974e:6ee8::/48"; }
        ];
      };
    } // hosthelper.groups.wireguard.g_systemd_network_networkconfig;
    netdevs = {
      "he6" = {
        netdevConfig = {
          Name = "he6";
          Kind = "sit";
          MTUBytes = "1480";
        };
        tunnelConfig = {
          Local = "195.20.227.176";
          Remote = "216.66.80.30";
          TTL = 255;
        };
      };
      "30-wg-fdg" = {
        netdevConfig = {
          Kind = "wireguard";
          Name = "wg-fdg";
        };
        wireguardConfig = {
          PrivateKeyFile = config.sops.secrets."hosts/enari/wireguard_wg-fdg_privatekey".path;
        };
        wireguardPeers = [{
          wireguardPeerConfig = {
            AllowedIPs = [ "fd59:974e:6ee8::/64" ];
            PublicKey = "79NbBslDrdK5fllB4+6wA9mUV7sVQCtAaPsojW0JJ0U=";
            Endpoint = "martian.infra.fahrplandatengarten.de:40000";
          };
        }];
      };
    } // hosthelper.groups.wireguard.g_systemd_network_netdevconfig;
  };
}