{ lib, config, ... }:

let
  hosthelper = import ../../hosts/helper.nix { inherit lib config; };
in
{
  l.sops.secrets."hosts/gaika/wireguard_wg-server_privatekey".owner = "systemd-network";
  networking.firewall.allowedUDPPorts = [ 51441 ];

  systemd.network.netdevs = hosthelper.groups.wireguard.g_systemd_network_netdevconfig;
  systemd.network.networks = hosthelper.groups.wireguard.g_systemd_network_networkconfig;

  networking.firewall.extraForwardRules = ''
    ct state invalid drop
    ct state established,related accept

    iifname eth0 oifname wg-server ct state new accept
    iifname wg-server oifname eth0 ct state new accept
  '';
}
