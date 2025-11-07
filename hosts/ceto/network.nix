{ config, pkgs, ... }:

{
  networking.useDHCP = false;
  networking.hostName = "ceto";
  networking.domain = "net.leona.is";

  systemd.network = {
    links = {
      "10-eth0" = {
        matchConfig.MACAddress = "10:ff:e0:e3:d6:e5";
        linkConfig = {
          Name = "eth0";
          WakeOnLan = "magic";
        };
      };
      "10-sfp0" = {
        matchConfig.MACAddress = "ec:0d:9a:2c:22:30";
        linkConfig = {
          Name = "sfp0";
          WakeOnLan = "magic";
        };
      };
    };
    networks = {
      "10-eth0" = {
        DHCP = "no";
        matchConfig.Name = "eth0";
        linkConfig = {
          RequiredForOnline = "no";
        };
        networkConfig = {
          IPv6AcceptRA = "no";
        };
      };
      "10-sfp0" = {
        DHCP = "yes";
        matchConfig.Name = "sfp0";
        linkConfig = {
          RequiredForOnline = "yes";
        };
      };
    };
  };
}
