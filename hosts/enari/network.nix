{ lib, config, ... }:
let
  hosthelper = import ../../hosts/helper.nix { inherit lib config; };
in
{
  l.sops.secrets."hosts/enari/wireguard_wg-server_privatekey".owner = "systemd-network";
  networking.hostName = "enari";
  networking.domain = "net.leona.is";
  networking.firewall.allowedUDPPorts = [ 51441 ];
  systemd.network = {
    links."10-eth0" = {
      matchConfig.MACAddress = "02:01:6b:d9:43:26";
      linkConfig.Name = "eth0";
    };
    networks = {
      "10-eth0" = {
        DHCP = "yes";
        matchConfig = {
          Name = "eth0";
        };
      };
    } // hosthelper.groups.wireguard.g_systemd_network_networkconfig;
    netdevs = hosthelper.groups.wireguard.g_systemd_network_netdevconfig;
  };
}
