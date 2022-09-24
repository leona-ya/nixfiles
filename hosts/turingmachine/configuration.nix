{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../profiles/base
    ../../profiles/desktop
    ./network.nix
    ./wireguard.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.editor = false;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "zfs" ];
  boot.kernelParams = [
    "zfs.zfs_arc_max=6442450944"
    "zfs.zfs_arc_min=1024000000"
  ];
  networking.hostId = "a4232228";

  l.sops.secrets = {
    "hosts/turingmachine/alt_rsa_ssh_key".owner = "leona";
    "hosts/turingmachine/user_leona_pw".neededForUsers = true;
  };

  services.upower = {
    enable = true;
    percentageLow = 10;
    percentageCritical = 7;
    percentageAction = 5;
  };
  systemd.services.upower.wantedBy = lib.mkForce [ "multi-user.target" ];

  users.users.leona.passwordFile = config.sops.secrets."hosts/turingmachine/user_leona_pw".path;
  security.sudo.wheelNeedsPassword = true;

  home-manager.users.leona = {
    programs.ssh.extraConfig = ''
      IdentityFile ${config.sops.secrets."hosts/turingmachine/alt_rsa_ssh_key".path}
    '';
  };
  l.backups = {
    enable = true;
    excludes = [
      "/var/cache"
      "/var/lock"
      "/var/spool"
      "/var/log"
      "/home/leona/.local/share/containers"
      "/home/leona/sync/nas"
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

  services.nginx.virtualHosts = {
    "legitima.turingmachine.net.leona.is" = {
      enableACME = true;
      forceSSL = true;
      locations."/".proxyPass = "http://localhost:8000";
    };
  };
  system.stateVersion = "20.09";
}
