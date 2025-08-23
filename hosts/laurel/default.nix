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
    ../../services/outline
    ../../services/vaultwarden
    ../../services/netbox
    ../../services/tandoor
    ../../services/gotosocial-is
  ];

  deployment.buildOnTarget = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "zfs" ];
  networking.hostId = "ec9b76dc";
  boot.initrd.kernelModules = [ "virtio_gpu" ];
  boot.kernelParams = [
    "zfs.zfs_arc_max=1024000000"
    "console=tty"
  ];

  l.backups.enable = true;

  users.users = {
    nginx.uid = 60;
    postgres.uid = 71;
    matrix-synapse.uid = 224;
    vaultwarden.uid = 992;
    hedgedoc.uid = 994;
    acme.uid = 996;
  };
  users.groups = {
    nginx.gid = 60;
    postgres.gid = 71;
    matrix-synapse.gid = 224;
    vaultwarden.gid = 990;
    hedgedoc.gid = 993;
    acme.gid = 995;
  };
  services.postgresql.package = pkgs.postgresql_15;

  system.stateVersion = "22.11";
}
