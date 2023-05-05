{ config, pkgs, modulesPath, ... }:

{
  imports = [
      ./hardware-configuration.nix
      ./network.nix
      ../../profiles/base
      ../../profiles/zfs-nopersist
      ../../services/nextcloud
      ../../services/web
      ../../services/firefly-iii
#      ../../services/grocy
      ../../services/ical-merger
      ../../services/dns-kresd
  ];

  boot.loader.grub = {
    enable = true;
    version = 2;
    zfsSupport = true;
    device = "/dev/sda";
  };
  boot.kernelParams = [
    "zfs.zfs_arc_max=1024000000"
  ];
  networking.hostId = "1f9e2eb3";
  services.qemuGuest.enable = true;

  services.kresd.listenPlain = [
    "127.0.0.1:53"
    "[::1]:53"
    "[fd8f:d15b:9f40:c21::1]:53"
    "[fd8f:d15b:9f40:900::1]:53"
  ];

  l.backups.enable = true;
  l.telegraf = {
    enable = true;
    host = "[fd8f:d15b:9f40:c21::1]";
    diskioDisks = [ "sda" ];
  };
  l.nginx-sni-proxy = {
    enable = true;
    upstreamHosts = {
      "laurel.net.leona.is" = [
        "matrix.leona.is"
        "md.leona.is"
        "paperless.leona.is"
        "pass.leona.is"
        "todo.leona.is"
        "social.haj.gf"
      ];
      "ladon.net.leona.is" = [
        "auth.em0lar.dev"
        "hydra.sso.leona.is"
        "sso.leona.is"
      ];
      "thia.wg.net.leona.is" = [
        "yt.leona.is"
      ];
    };
  };

  users.users = {
    nextcloud.uid = 994;
    firefly-iii.uid = 995;
    acme.uid = 996;
    postgres.uid = 71;
  };
  users.groups = {
    nextcloud.gid = 993;
    acme.gid = 995;
    firefly-iii.gid = 994;
    postgres.gid = 71;
  };
  
  services.postgresql.package = pkgs.postgresql_14;

  system.stateVersion = "23.05";
}
