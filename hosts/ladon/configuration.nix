{ config, pkgs, modulesPath, lib, ... }:

{
  imports = [
      ./hardware-configuration.nix
      ./network.nix
      ../../profiles/base
      ../../profiles/zfs-nopersist
      ../../services/ldap
      ../../services/keycloak
      ../../services/hydra-sso
  ];
  boot.loader.grub = {
      enable = true;
      version = 2;
      zfsSupport = true;
      device = "/dev/sda";
  };
  boot.supportedFilesystems = ["zfs"];
  boot.kernelParams = [
    "zfs.zfs_arc_max=268000000"
  ];
  networking.hostId = "42539036";

  l.backups.enable = true;
  l.telegraf = {
    enable = true;
    host = "[fd8f:d15b:9f40:c21:200::1]";
    diskioDisks = [ "sda" ];
  };

  services.postgresql.package = pkgs.postgresql_14;

  system.stateVersion = "22.11";
}
