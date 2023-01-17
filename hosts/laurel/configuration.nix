{ config, pkgs, modulesPath, lib, ... }:

{
  imports = [
      ./hardware-configuration.nix
      ../../profiles/base
      ../../profiles/zfs-nopersist
      ../../services/hedgedoc
      ../../services/matrix
      ../../services/paperless
#      ../../services/haj-social
      ../../services/vaultwarden
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

  networking.hostName = "newlaurel";
  networking.domain = "net.leona.is";
  systemd.network = {
    links."10-eth0" = {
      matchConfig.MACAddress = "96:00:01:d0:16:51";
      linkConfig.Name = "eth0";
    };
    networks."10-eth0" = {
      DHCP = "yes";
      matchConfig = {
        Name = "eth0";
      };
      address = [
        "2a01:4f8:c012:b172::1/64"
      ];
      dns = [ "2001:4860:4860::8888" ];
      routes = [
        { routeConfig = { Destination = "::/0"; Gateway = "fe80::1"; GatewayOnLink = true; }; }
      ];
    };
    links."10-eth-nat" = {
      matchConfig.MACAddress = "86:00:00:32:55:c5";
      linkConfig.Name = "eth-nat";
    };
    networks."10-eth-nat" = {
      matchConfig.Name = "eth-nat";
      address = [ "10.62.41.3/32" ];
      routes = [
        { routeConfig = { Destination = "0.0.0.0/0"; Gateway = "10.62.41.1"; GatewayOnLink = true; }; }
      ];
    };
  };
  networking.useHostResolvConf = false;
  l.nftables.checkIPTables = false;
#  l.backups.enable = true;
#  l.telegraf = {
#    enable = true;
#    host = "[fd8f:d15b:9f40:c41:5054:ff:fe0a:845]";
#    diskioDisks = [ "vda" ];
#  };

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
