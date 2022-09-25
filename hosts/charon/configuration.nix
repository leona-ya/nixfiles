{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./networking
    ../../profiles/base
    ../../profiles/zfs-nopersist
    ../../services/dns-kresd
  ];

  boot.loader.generationsDir.copyKernels = true;
  boot.loader.grub = {
    enable = true;
    version = 2;
    zfsSupport = true;
    copyKernels = true;
    devices = [
      "/dev/disk/by-id/nvme-SAMSUNG_MZVL2512HCJQ-00B00_S675NF0R405351"
      "/dev/disk/by-id/nvme-SAMSUNG_MZVL2512HCJQ-00B00_S675NF0R405352"
      "/dev/disk/by-id/nvme-SAMSUNG_MZVL2512HCJQ-00B00_S675NX0T346934"
    ];
  };

  boot.supportedFilesystems = [ "zfs" ];
  boot.kernelParams = [
    "zfs.zfs_arc_max=10240000000"
    "zfs.zfs_arc_min=1024000000"
  ];
  networking.hostId = "fb4b69a7";
  boot.kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;
  nix.distributedBuilds = false;

  networking.hostName = "charon";
  networking.domain = "net.leona.is";

  l.nftables.checkIPTables = false;
  virtualisation.libvirtd.enable = true;
  security.polkit.enable = true;

  l.telegraf = {
    enable = true;
    host = "[fd8f:d15b:9f40:0c40::1]";
    diskioDisks = [ "nvme0n1" "nvme1n1" "nvme2n1" ];
    extraInputs = {
      zfs = {
        poolMetrics = true;
        datasetMetrics = true;
      };
    };
  };
  services.telegraf.extraConfig.inputs.net.interfaces = [ "br*" "wg-*" "eth0" ];

  system.stateVersion = "22.11";
}


