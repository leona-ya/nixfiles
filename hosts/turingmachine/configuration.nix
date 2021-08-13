{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../common
    ../../desktop
    ./network.nix
    ./wireguard.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.editor = false;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "zfs" ];
  boot.kernelParams = [ "zfs.zfs_arc_max=1024000000" ];
  networking.hostId = "a4232228";

  em0lar.secrets = {
    "alt_rsa_ssh_key".owner = "em0lar";
    "user-em0lar-password".owner = "root";
  };

  services.upower = {
    enable = true;
    percentageLow = 10;
    percentageCritical = 7;
    percentageAction = 5;
  };
  systemd.services.upower.wantedBy = lib.mkForce [ "multi-user.target" ];

  users.users.em0lar.passwordFile = config.em0lar.secrets.user-em0lar-password.path;
  security.sudo.wheelNeedsPassword = true;

  home-manager.users.em0lar = {
    home.file.alt_rsa_ssh_key = {
      source = config.em0lar.secrets."alt_rsa_ssh_key".path;
      target = ".ssh/alt_rsa";
    };

    programs.ssh.extraConfig = ''
      IdentityFile ~/.ssh/alt_rsa
    '';
  };
  em0lar.backups = {
    enable = true;
    excludes = [
      "/var/cache"
      "/var/lock"
      "/var/spool"
      "/var/log"
      "/home/em0lar/.local/share/containers"
      "/home/em0lar/sync/nas"
      "/var/lib/containers"
      "**/node_modules"
      "**/.venv"
      "/home/*/.cache"
      "**/Cache"
    ];
    enableSystemdTimer = false;
  };
  system.stateVersion = "20.09";
}
