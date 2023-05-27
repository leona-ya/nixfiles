{ inputs, ... }:

{
  imports = [
    inputs.mailserver.nixModule
    ./hardware-configuration.nix
    ./network.nix
    ../../profiles/zfs-nopersist
    ../../profiles/encrypted-fs
    ../../services/dns-knot/primary
    ../../services/mail
  ];

  boot.loader.grub = {
    enable = true;
    version = 2;
    zfsSupport = true;
    device = "/dev/sda";
  };
  boot.supportedFilesystems = ["zfs"];
  boot.zfs.devNodes = "/dev/disk/by-path";
  networking.hostId = "a69a4457";

  l.telegraf = {
    enable = true;
    host = "[fd8f:d15b:9f40:c21:300::1]";
    diskioDisks = [ "sda" ];
  };
  l.backups.enable = true;

  system.stateVersion = "23.05";
}


