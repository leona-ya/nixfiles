{ config, pkgs, ... }:

{
  networking.hostName = "arche";
  networking.domain = "net.leona.is";

  systemd.network = {
    links."10-eth-rcy" = {
      matchConfig.MACAddress = "00:2b:67:19:c4:f0";
      linkConfig = {
        Name = "eth-rcy";
      };
    };
    networks."10-eth-rcy" = {
      DHCP = "yes";
      matchConfig.Name = "eth-rcy";
      linkConfig = {
        RequiredForOnline = "yes";
      };
    };
  };
}
