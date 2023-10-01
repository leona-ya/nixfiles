{ pkgs, ... }: {
  imports = [
      ./hardware-configuration.nix
      ./network.nix
      ../../profiles/zfs-nopersist
      ../../profiles/encrypted-fs
      ../../services/monitoring
      ../../services/dns-knot/secondary
    ];

  # Secondary DNS
  services.knot.settings.server.listen = [
    "127.0.0.11@53"
    "195.20.227.176@53"
    "2001:470:1f0b:1112::1@53"
    "fd8f:d15b:9f40:c10::1@53"
  ];
 
 boot.loader.grub = {
    enable = true;
    zfsSupport = true;
    device = "/dev/vda";
  };
  boot.supportedFilesystems = [ "zfs" ];
  boot.kernelParams = [
    "zfs.zfs_arc_max=1024000000"
  ];
  networking.hostId = "fed5b931";

#  l.backups.enable = true;
  l.telegraf = {
    enable = true;
    host = "[fd8f:d15b:9f40:c10::1]";
    diskioDisks = [ "vda" ];
  };

  users.users = {
    acme.uid = 996;
#    postgres.uid = 71;
  };
  users.groups = {
    acme.gid = 995;
#    postgres.gid = 71;
  };
  
  services.postgresql.package = pkgs.postgresql_15;

  system.stateVersion = "23.11";
}
