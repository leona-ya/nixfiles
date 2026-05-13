{ config, pkgs, ... }:

{
  networking.useDHCP = false;
  networking.hostName = "thizy";
  networking.domain = "net.leona.is";

  networking.wireless.iwd = {
    enable = true;
    settings = {
      General = {
        AddressRandomization = "network";
      };
    };
  };
  systemd.network = {
    networks."99-ethernet-default-dhcp" = {
      matchConfig = {
        Type = "ether";
        Kind = "!*";
      };
      DHCP = "yes";
      networkConfig.IPv6PrivacyExtensions = "kernel";
    };
    networks."10-wlan0" = {
      DHCP = "yes";
      matchConfig.Name = "wlan0";
      networkConfig.IPv6PrivacyExtensions = "kernel";
    };
  };
}
