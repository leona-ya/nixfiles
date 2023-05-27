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
      ../../services/nomsable
#      ../../services/vikunja
  ];
  boot.loader.grub = {
    enable = true;
    version = 2;
    zfsSupport = true;
    device = "/dev/sda";
  };
  boot.supportedFilesystems = [ "zfs" ];

  networking.hostId = "ec9b76dc";
  boot.kernelParams = [
    "zfs.zfs_arc_max=1024000000"
  ];

  l.backups.enable = true;
  l.telegraf = {
    enable = true;
    host = "[fd8f:d15b:9f40:0c21:100::1]";
    diskioDisks = [ "sda" ];
  };

  services.postgresql = {
    package = pkgs.postgresql_14;
    settings = {
      max_connections = 200;
      shared_buffers = "768MB";
      effective_cache_size = "2304MB";
      maintenance_work_mem = "192MB";
      checkpoint_completion_target = 0.9;
      wal_buffers = "16MB";
      default_statistics_target = 100;
      random_page_cost = 1.1;
      effective_io_concurrency = 200;
      work_mem = "1966kB";
      min_wal_size = "1GB";
      max_wal_size = "4GB";
    };
  };
  system.stateVersion = "22.11";
}
