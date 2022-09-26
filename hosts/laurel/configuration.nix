{ config, pkgs, modulesPath, lib, ... }:

{
  imports = [
      ./hardware-configuration.nix
      ../../profiles/base
      ../../profiles/zfs-nopersist
      ../../services/hedgedoc
      ../../services/matrix
      ../../services/netbox
      ../../services/paperless
      ../../services/haj-social
      ../../services/vaultwarden
      ../../services/vikunja
  ];
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = ["zfs"];
  boot.zfs.devNodes = "/dev/disk/by-path";
  networking.hostId = "47cdd0f6";
  boot.kernelParams = [
    "zfs.zfs_arc_max=1024000000"
  ];

  networking.hostName = "laurel";
  networking.domain = "net.leona.is";
  systemd.network = {
    links."10-eth-internal" = {
      matchConfig.MACAddress = "52:54:00:0a:08:45";
      linkConfig.Name = "eth-internal";
    };
    networks."10-eth-internal" = {
      DHCP = "yes";
      matchConfig = {
        Name = "eth-internal";
      };
    };

    links."10-eth-internet" = {
      matchConfig.MACAddress = "52:54:00:20:44:2b";
      linkConfig.Name = "eth-internet";
    };
    networks."10-eth-internet" = {
      DHCP = "yes";
      matchConfig = {
        Name = "eth-internet";
      };
    };
  };
  networking.useHostResolvConf = false;
  l.nftables.checkIPTables = false;
  l.backups.enable = true;
  l.telegraf = {
    enable = true;
    host = "[fd8f:d15b:9f40:c41:5054:ff:fe0a:845]";
    diskioDisks = [ "vda" ];
  };

  services.postgresql.package = pkgs.postgresql_14;
  system.stateVersion = "22.11";
}
