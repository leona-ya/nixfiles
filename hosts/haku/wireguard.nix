{ lib, config, ... }:
let
  hosthelper = import ../../hosts { inherit lib config; };
in {
  networking.firewall.allowedUDPPorts = [
    51440
    51441
    51442
  ];
  l.sops.secrets = {
    "hosts/haku/wireguard_wg-public_privatekey".owner = "systemd-network";
    "hosts/haku/wireguard_wg-server_privatekey".owner = "systemd-network";
  };
  l.nftables.extraForward = ''
    ct state invalid drop
    ct state established,related accept
    iifname wg-public ct state new accept
    oifname wg-public ct state new accept
  '';
  systemd.network = {
    netdevs = hosthelper.groups.wireguard.g_systemd_network_netdevconfig;
    networks = hosthelper.groups.wireguard.g_systemd_network_networkconfig;
  };
}
