{ config, pkgs, modulesPath, ... }:

{
  imports = [
      ./hardware-configuration.nix
      ./network.nix
      ../../profiles/base
      ../../profiles/zfs-nopersist
      ../../services/nextcloud
      ../../services/web
      ../../services/firefly-iii
      ../../services/grocy
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = ["zfs"];
  boot.zfs.devNodes = "/dev/disk/by-path";
  boot.kernelParams = [
    "zfs.zfs_arc_max=1024000000"
  ];
  networking.hostId = "decb934d";

  services.qemuGuest.enable = true;

  l.backups.enable = true;
  l.telegraf = {
    enable = true;
    host = "[fd8f:d15b:9f40:c41:5054:ff:fe3a:685c]";
    diskioDisks = [ "vda" ];
  };

  services.postgresql.package = pkgs.postgresql_14;

  system.stateVersion = "22.11";
}
