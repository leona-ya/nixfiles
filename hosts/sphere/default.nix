{ lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./network.nix
    ../../profiles/zfs-nopersist
    ../../profiles/encrypted-fs
    ../../services/keycloak
    ../../services/ldap
  ];

  deployment.buildOnTarget = true;
  deployment.targetHost = "2a01:4f8:c012:b842::1";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelParams = [
    "zfs.zfs_arc_max=1024000000"
    "console=tty"
  ];
  boot.initrd.kernelModules = [ "virtio_gpu" ];
  networking.hostId = "fd5958ae";
  services.qemuGuest.enable = true;

  l.backups.enable = true;
  l.telegraf = {
    enable = true;
    host = "[fd8f:d15b:9f40:c21:400::1]";
    diskioDisks = [ "sda" ];
  };
  l.promtail = {
    enable = true;
    enableNginx = true;
  };

  users.users = {
    acme.uid = 996;
    postgres.uid = 71;
    nginx.uid = 60;
    telegraf.uid = 256;
    openldap.uid = 994;
    keycloak.uid = 995;
  };
  users.groups = {
    acme.gid = 995;
    postgres.gid = 71;
    nginx.gid = 60;
    telegraf.gid = 994;
    openldap.gid = 992;
    keycloak.gid = 993;
  };

  services.postgresql.package = pkgs.postgresql_15;

  system.stateVersion = "23.05";
}
