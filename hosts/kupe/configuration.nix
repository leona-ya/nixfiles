{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../profiles/base
    ../../profiles/zfs-nopersist
    ../../services/dns-knot/primary
    ../../services/mail
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = ["zfs"];
  boot.zfs.devNodes = "/dev/disk/by-path";
  networking.hostId = "a69a4457";

  networking.hostName = "kupe";
  networking.domain = "net.leona.is";

  systemd.network = {
    links."10-eth-internal" = {
      matchConfig.MACAddress = "52:54:00:b8:64:9c";
      linkConfig.Name = "eth-internal";
    };
    networks."10-eth-internal" = {
      DHCP = "yes";
      matchConfig = {
          Name = "eth-internal";
      };
    };

    links."10-eth-internet" = {
      matchConfig.MACAddress = "52:54:00:91:96:da";
      linkConfig.Name = "eth-internet";
    };
    networks."10-eth-internet" = {
      DHCP = "yes";
      matchConfig = {
          Name = "eth-internet";
      };
    };
  };

  l.telegraf = {
    enable = true;
    host = "[fd8f:d15b:9f40:10:5054:ff:fec0:8539]";
    diskioDisks = [ "vda" ];
  };
  l.backups.enable = true;

  system.stateVersion = "22.05";
}


