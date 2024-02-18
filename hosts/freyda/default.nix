{ config, lib, inputs, pkgs, ... }:

{
  imports = [
    inputs.nixos-hardware.nixosModules.framework-13-7040-amd
    ./hardware-configuration.nix
    ../../profiles/desktop
    ../../profiles/desktop/sway
    ../../profiles/bcachefs
    ./network.nix
    ./kanshi.nix
    ./wireguard.nix
  ];

  deployment.allowLocalDeployment = true;
#  deployment.targetHost = "fd8f:d15b:9f40:901::1";

  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.editor = false;
  boot.loader.efi.canTouchEfiVariables = true;

  l.sops.secrets = {
    "profiles/desktop/alt_rsa_ssh_key".owner = "leona";
    "profiles/desktop/user_leona_pw".neededForUsers = true;
  };

  services.upower = {
    enable = true;
    percentageLow = 10;
    percentageCritical = 7;
    percentageAction = 5;
  };
  systemd.services.upower.wantedBy = lib.mkForce [ "multi-user.target" ];

  users.users.leona.hashedPasswordFile = config.sops.secrets."profiles/desktop/user_leona_pw".path;
  security.sudo-rs.wheelNeedsPassword = true;

  home-manager.users.leona = {
    programs.ssh.extraConfig = ''
      IdentityFile ${config.sops.secrets."profiles/desktop/alt_rsa_ssh_key".path}
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
      "/home/leona/dev"
      "/home/leona/nc"
      "/var/lib/containers"
      "**/node_modules"
      "**/.venv"
      "**/target"
      "/home/*/.cache"
      "/home/*/.rustup"
      "/home/*/.local/share/Steam"
      "/home/*/.cargo"
      "**/Cache"
      "**/tmp"
    ];
    enableSystemdTimer = false;
  };

  hardware.framework.amd-7040.preventWakeOnAC = true;
  boot.kernelParams = [ "amdgpu.sg_display=0" ];

  system.stateVersion = "23.05";
}
