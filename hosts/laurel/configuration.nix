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
