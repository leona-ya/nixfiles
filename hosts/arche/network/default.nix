{
  config,
  lib,
  pkgs,
  ...
}:

let
  hosthelper = import ../../helper.nix { inherit lib config; };
in
{
  networking.hostName = "arche";
  networking.domain = "net.infinitespace.dev";
  l.sops.secrets."hosts/arche/wireguard_wg-server_privatekey".owner = "systemd-network";

  systemd.network = {
    links."10-eth-rcy" = {
      matchConfig.MACAddress = "00:2b:67:19:c4:f0";
      linkConfig = {
        Name = "eth-rcy";
      };
    };
    networks = {
      "10-eth-rcy" = {
        DHCP = "yes";
        matchConfig.Name = "eth-rcy";
        linkConfig = {
          RequiredForOnline = "yes";
        };
      };
    }
    // hosthelper.groups.wireguard.g_systemd_network_networkconfig;
    netdevs = hosthelper.groups.wireguard.g_systemd_network_netdevconfig;
  };
}
