{ config, pkgs, ... }:

{
  networking.useDHCP = false;
  networking.hostName = "thia";
  networking.domain = "net.leona.is";

  systemd.network = {
    links."10-eth0" = {
      matchConfig.MACAddress = "c4:62:37:00:3d:a0";
      linkConfig.Name = "eth0";
    };
    networks."10-eth0" = {
      DHCP = "yes";
      matchConfig.Name = "eth0";
      linkConfig = {
        RequiredForOnline = "yes";
      };
      address = [
        "fd8f:d15b:9f40:101::100/64"
        "fd8f:d15b:9f40:101::1312/64"
      ];
    };
  };
}
