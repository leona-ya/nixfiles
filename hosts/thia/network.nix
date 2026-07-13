{
  config,
  lib,
  pkgs,
  ...
}:

let
  hosthelper = import ../helper.nix { inherit lib config; };
in
{
  networking.useDHCP = false;
  networking.hostName = "thia";
  networking.domain = "net.leona.is";

  l.sops.secrets."hosts/thia/wireguard_wg-server_privatekey".owner = "systemd-network";
  systemd.network = {
    netdevs = hosthelper.groups.wireguard.g_systemd_network_netdevconfig;
    links."10-eth0" = {
      matchConfig.MACAddress = "c4:62:37:00:3d:a0";
      linkConfig.Name = "eth0";
    };
    networks = {
      "10-eth0" = {
        DHCP = "yes";
        matchConfig.Name = "eth0";
        linkConfig = {
          RequiredForOnline = "yes";
        };
      };
    }
    // hosthelper.groups.wireguard.g_systemd_network_networkconfig;
  };
}
