{ config, pkgs, modulesPath, lib, ... }:

{
  imports = [
      ./hardware-configuration.nix
      ./network.nix
      ../../profiles/zfs-nopersist
      ../../profiles/encrypted-fs
      ../../services/hedgedoc
      ../../services/matrix
      ../../services/haj-social
      ../../services/vaultwarden
#      ../../services/nomsable
#      ../../services/vikunja
  ];

  deployment.buildOnTarget = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "zfs" ];
  boot.kernelPackages = lib.mkForce pkgs.linuxKernel.packages.linux_6_1;
  networking.hostId = "ec9b76dc";
  boot.initrd.kernelModules = [ "virtio_gpu" ];
  boot.kernelParams = [
    "zfs.zfs_arc_max=1024000000"
    "console=tty"
  ];

  l.backups.enable = true;
  l.telegraf = {
    enable = true;
    host = "[fd8f:d15b:9f40:0c21:100::1]";
    diskioDisks = [ "sda" ];
  };

  users.users = {
    nginx.uid = 60;
    postgres.uid = 71;
    matrix-synapse.uid = 224;
    telegraf.uid = 256;
    vaultwarden.uid = 992;
    pleroma.uid = 993;
    hedgedoc.uid = 994;
    acme.uid = 996;
  };
  users.groups = {
    nginx.gid = 60;
    postgres.gid = 71;
    matrix-synapse.gid = 224;
    telegraf.gid = 991;
    vaultwarden.gid = 990;
    pleroma.gid = 992;
    hedgedoc.gid = 993;
    acme.gid = 995;
  };
  services.postgresql.package = pkgs.postgresql_14;
  system.stateVersion = "22.11";
}
