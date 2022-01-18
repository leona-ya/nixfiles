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

  em0lar.sops.secrets = {
    "hosts/turingmachine/alt_rsa_ssh_key".owner = "em0lar";
    "hosts/turingmachine/user_em0lar_pw".neededForUsers = true;
  };

  services.upower = {
    enable = true;
    percentageLow = 10;
    percentageCritical = 7;
    percentageAction = 5;
  };
  systemd.services.upower.wantedBy = lib.mkForce [ "multi-user.target" ];

  users.users.em0lar.passwordFile = config.sops.secrets."hosts/turingmachine/user_em0lar_pw".path;
  #security.sudo.wheelNeedsPassword = true;

  home-manager.users.em0lar = {
    programs.ssh.extraConfig = ''
      IdentityFile ${config.sops.secrets."hosts/turingmachine/alt_rsa_ssh_key".path}
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
      "**/target"
      "/home/*/.cache"
      "/home/*/.rustup"
      "**/Cache"
    ];
    enableSystemdTimer = false;
  };
  system.stateVersion = "20.09";
}
