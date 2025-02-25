{ lib, config, ... }:
let
  hosthelper = import ../../hosts/helper.nix { inherit lib config; };
in
{
  l.sops.secrets."hosts/rutile/wireguard_wg-fdg_privatekey".owner = "systemd-network";
  l.sops.secrets."hosts/rutile/wireguard_wg-server_privatekey".owner = "systemd-network";
  networking.hostName = "rutile";
  networking.domain = "net.leona.is";
  networking.firewall.allowedUDPPorts = [ 51441 ];
  systemd.network = {
    links."10-eth0" = {
      matchConfig.MACAddress = "02:01:f5:e5:d5:f4";
      linkConfig.Name = "eth0";
    };
    networks = {
      "10-eth0" = {
        DHCP = "yes";
        matchConfig = {
          Name = "eth0";
        };
      };
      "30-wg-fdg" = {
        name = "wg-fdg";
        address = [
          "fd59:974e:6ee8:1001::1/64"
        ];
        routes = [
          { Destination = "fd59:974e:6ee8::/48"; }
        ];
      };
    } // hosthelper.groups.wireguard.g_systemd_network_networkconfig;
    netdevs = {
      "30-wg-fdg" = {
        netdevConfig = {
          Kind = "wireguard";
          Name = "wg-fdg";
        };
        wireguardConfig = {
          PrivateKeyFile = config.sops.secrets."hosts/rutile/wireguard_wg-fdg_privatekey".path;
        };
        wireguardPeers = [{
          AllowedIPs = [ "fd59:974e:6ee8::/64" ];
          PublicKey = "79NbBslDrdK5fllB4+6wA9mUV7sVQCtAaPsojW0JJ0U=";
          Endpoint = "martian.infra.fahrplandatengarten.de:40000";
        }];
      };
    } // hosthelper.groups.wireguard.g_systemd_network_netdevconfig;
  };
}

