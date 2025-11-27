{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    inputs.disko.nixosModules.disko
    ./hardware-configuration.nix
    ../../profiles/desktop
    ../../profiles/desktop/sway
    ./disko.nix
    ./network.nix
    ./kanshi.nix
  ];

  deployment.allowLocalDeployment = true;
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.editor = false;
  boot.loader.efi.canTouchEfiVariables = true;
  l.remote-unlock.enable = true;
  
  nix.distributedBuilds = false;
  nix.settings.max-jobs = 10;
  zramSwap = {
    enable = true;
  };

  l.backups = {
    enable = false;
    paths = [
      "/home"
      "/root"
    ];
    excludes = [
      "/home/leona/.local/share/containers"
      "/home/leona/nextcloud"
      "**/node_modules"
      "**/.venv"
      "**/target"
      "/home/*/.cache"
      "/home/*/.rustup"
      "/home/*/.local/share/Steam"
      "/home/*/.m2"
      "/home/*/tmp"
      "**/Cache"
    ];
    enableSystemdTimer = false;
  };

  l.sops.secrets = {
    "profiles/desktop/user_leona_pw".neededForUsers = true;
  };

  users.users.leona.hashedPasswordFile = config.sops.secrets."profiles/desktop/user_leona_pw".path;
  security.sudo-rs.wheelNeedsPassword = true;

  services.hardware.openrgb = {
    enable = true;
    motherboard = "amd";
  };

  system.stateVersion = "25.05";
}
