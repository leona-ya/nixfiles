{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./initrd.nix
    ./wireguard.nix
    ../../services/dns-knot/primary
    ../../common
    ../../services/mail
    ../../services/convos
    ../../services/dns-kresd
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "kupe";
  networking.domain = "net.em0lar.dev";

  systemd.network = {
    links."10-eth0" = {
      matchConfig.MACAddress = "52:54:00:c0:85:39";
      linkConfig.Name = "eth0";
    };
    networks."10-eth0" = {
      DHCP = "yes";
      matchConfig = {
        Name = "eth0";
      };
      networkConfig.IPv6PrivacyExtensions = "no";
    };
  };

  em0lar.telegraf = {
    enable = true;
    host = "[fd8f:d15b:9f40:10:5054:ff:fec0:8539]";
    diskioDisks = [ "vda" ];
  };
  em0lar.backups.enable = true;

  system.stateVersion = "22.05";
}


