{ lib, pkgs, ... }:

{
  imports = [
      ./hardware-configuration.nix
      ./network.nix
      ../../profiles/zfs-nopersist
      ../../profiles/encrypted-fs
      ../../services/web
      ../../services/firefly-iii
      ../../services/dns-kresd
      ../../services/snipe-it
  ];

  deployment.buildOnTarget = true;
  
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelParams = [
    "zfs.zfs_arc_max=1024000000"
    "console=tty"
  ];
  boot.kernelPackages = lib.mkForce pkgs.linuxKernel.packages.linux_6_1;
  boot.initrd.kernelModules = [ "virtio_gpu" ];
  networking.hostId = "aeb28f21";
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
  l.promtail = {
    enable = true;
    enableNginx = true;
  };
  l.nginx-sni-proxy = {
    enable = true;
    upstreamHosts = {
      "laurel.net.leona.is" = [
        "matrix.leona.is"
        "sliding-sync.matrix.leona.is"
        "md.leona.is"
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
        "cloud.maroni.me"
        "cloud.leona.is"
        "yt.leona.is"
      ];
      "sphere.net.leona.is" = [
        "auth.leona.is"
      ];
    };
  };

  users.users = {
    firefly-iii.uid = 995;
    acme.uid = 996;
    postgres.uid = 71;
  };
  users.groups = {
    acme.gid = 995;
    firefly-iii.gid = 994;
    postgres.gid = 71;
  };
  
  services.postgresql.package = pkgs.postgresql_14;

  system.stateVersion = "23.05";
}
