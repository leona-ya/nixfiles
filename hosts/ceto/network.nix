{ config, pkgs, ... }:

{
  networking.useDHCP = false;
  networking.hostName = "ceto";
  networking.domain = "net.leona.is";

  systemd.network = {
    links."10-eth0" = {
      matchConfig.MACAddress = "9c:6b:00:97:b5:8a";
      linkConfig = {
        Name = "eth0";        
        WakeOnLan = "magic";
      };
    };
    networks."10-eth0" = {
      DHCP = "yes";
      matchConfig.Name = "eth0";
      linkConfig = {
        RequiredForOnline = "yes";
      };
    };
  };
}
