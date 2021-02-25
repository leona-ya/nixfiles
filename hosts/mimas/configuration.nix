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
    "backups_ssh_key".source-path = "${../../secrets/mimas/backup_ssh_key.gpg}";
    "backups_passphrase".source-path = "${../../secrets/mimas/backup_passphrase.gpg}";
    "alt_rsa_ssh_key" = {
      source-path = "${../../secrets/mimas/alt_rsa_ssh_key.gpg}";
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
    paths = [
      "/home"
      "/var"
      "/etc"
      "/root"
    ];
    excludes = [
      "/nix"
      "/var/cache"
      "/var/lock"
      "/var/spool"
      "/var/log"
      "/home/em0lar/.local/share/containers"
      "/var/lib/containers"
      "node_modules"
      ".venv"
      ".cache"
      "/tmp"
    ];
    repo = "backup@helene.int.sig.de.labcode.de:/mnt/backup/repos/unsynced/mimas.int.sig.de.em0lar.dev";
    encryptionPassCommand = "cat ${config.em0lar.secrets.backups_passphrase.path}";
    sshKeyFilePath = config.em0lar.secrets.backups_ssh_key.path;
    enableSystemdTimer = false;
  };
  system.stateVersion = "20.09";
}
