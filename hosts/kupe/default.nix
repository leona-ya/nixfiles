{ inputs, ... }:

{
  imports = [
    inputs.mailserver.nixosModule
    ./hardware-configuration.nix
    ./network.nix
    ../../profiles/zfs-nopersist
    ../../profiles/encrypted-fs
    ../../services/dns-knot/primary
    ../../services/dns-kresd
    ../../services/mail
  ];

  boot.loader.grub = {
    enable = true;
    zfsSupport = true;
    device = "/dev/sda";
  };
  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.devNodes = "/dev/disk/by-path";
  networking.hostId = "a69a4457";
  boot.kernelParams = [
    "zfs.zfs_arc_max=512000000"
  ];

  l.backups.enable = true;

  system.stateVersion = "23.05";
}


