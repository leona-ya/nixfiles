{ config, pkgs, ... }:

{
  networking.useDHCP = false;
  networking.hostName = "thia";
  networking.domain = "net.leona.is";

  systemd.network = {
    links."10-eth0" = {
      matchConfig.MACAddress = "a8:a1:59:44:71:de";
      linkConfig.Name = "eth0";
    };
    networks."10-eth0" = {
      DHCP = "yes";
      matchConfig.Name = "eth0";
      linkConfig = { RequiredForOnline = "yes"; };
      address = [
        "fd8f:d15b:9f40:101::100/64"
        "fd8f:d15b:9f40:101::1312/64"
      ];
    };
  };
}
