{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../profiles/desktop
    ../../profiles/desktop/sway
    ../../services/int-acme-ca
    ../../services/paperless
    ../../services/bn-smarthome
    ../../services/youtrack
    ../../services/nextcloud
    ./network.nix
    ./libvirt.nix
  ];

  deployment.allowLocalDeployment = true;
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.editor = false;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "zfs" ];
  boot.kernelParams = [
    "zfs.zfs_arc_max=6442450944"
    "zfs.zfs_arc_min=1024000000"
  ];
  zramSwap.enable = true;
  networking.hostId = "d5714cb9";
  nix.distributedBuilds = false;
  services.nginx.defaultListenAddresses = [
    "0.0.0.0"
    "[::1]"
    "[fd8f:d15b:9f40:101::1312]"
  ];

  l.telegraf = {
    enable = true;
    host = "[fd8f:d15b:9f40:101::1312]";
    diskioDisks = [ "nvme0n1" ];
  };

  l.backups = {
    enable = true;
    paths = [
      "/home"
      "/root"
      "/var/lib/paperless"
      "/var/lib/hass"
      "/var/lib/youtrack"
      "/var/lib/nextcloud"
    ];
    excludes = [
      "/var/cache"
      "/var/lock"
      "/var/spool"
      "/var/log"
      "/home/leona/.local/share/containers"
      "/var/lib/containers"
      "/home/leona/nextcloud"
      "**/node_modules"
      "**/.venv"
      "**/target"
      "/home/*/.cache"
      "/home/*/.rustup"
      "/home/*/.local/share/Steam"
      "/home/*/tmp"
      "**/Cache"
    ];
    enableSystemdTimer = false;
  };

  l.sops.secrets = {
    "profiles/desktop/alt_rsa_ssh_key".owner = "leona";
    "profiles/desktop/user_leona_pw".neededForUsers = true;
  };

  services.nginx.virtualHosts."thia.net.leona.is" = {
    enableACME = lib.mkForce true;
    forceSSL = lib.mkForce true;
  };
  security.acme.certs."thia.net.leona.is".server = "https://acme.int.leona.is/acme/acme/directory";

  home-manager.users.leona.programs.ssh.extraConfig = ''
    IdentityFile ${config.sops.secrets."profiles/desktop/alt_rsa_ssh_key".path}
  '';
  users.users.leona.hashedPasswordFile = config.sops.secrets."profiles/desktop/user_leona_pw".path;
  security.sudo-rs.wheelNeedsPassword = true;

  system.stateVersion = "23.05";
}
