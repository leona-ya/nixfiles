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
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "zfs" ];
  boot.kernelParams = [ "zfs.zfs_arc_max=1024000000" ];
  networking.hostId = "a4232228";

  em0lar.secrets = {
    "backup_ssh_key".owner = "root";
    "backup_passphrase".owner = "root";
    "alt_rsa_ssh_key" = {
      owner = "em0lar";
    };
  };

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
      "node_modules"
      ".venv"
      ".cache"
    ];
    repo = "ssh://backup@[fd8f:d15b:9f40:102:9cf1:ccff:fead:6e31]:61337/mnt/backup/repos/unsynced/mimas.int.sig.de.em0lar.dev";
    enableSystemdTimer = false;
  };
  system.stateVersion = "20.09";
}
