{ lib, config, ... }:

let
  hosthelper = import ../../hosts { inherit lib config; };
in {
  em0lar.sops.secrets."hosts/naiad/wireguard_wg-server_privatekey".owner = "systemd-network";
  networking.firewall.allowedUDPPorts = [ 51441 ];

  systemd.network.netdevs = hosthelper.groups.wireguard.g_systemd_network_netdevconfig;
  systemd.network.networks = hosthelper.groups.wireguard.g_systemd_network_networkconfig;
}
