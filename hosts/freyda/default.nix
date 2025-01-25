{ config, lib, inputs, pkgs, ... }:

{
  imports = [
    inputs.lanzaboote.nixosModules.lanzaboote
    inputs.nixos-hardware.nixosModules.framework-13-7040-amd
    ./hardware-configuration.nix
    ../../profiles/desktop
    ../../profiles/desktop/sway
    ./network.nix
    ./kanshi.nix
    ./wireguard.nix
  ];

  deployment.allowLocalDeployment = true;
  #  deployment.targetHost = "fd8f:d15b:9f40:901::1";

  boot.kernelPackages = lib.mkForce pkgs.linuxPackages_latest;
  boot.loader.systemd-boot.enable = lib.mkForce false;
  disabledModules = [ "${inputs.nixos-hardware}/common/cpu/amd/raphael/igpu.nix" ];

  zramSwap.enable = true;
  services.fstrim.enable = true;
  boot.initrd.luks.devices = {
    cryptroot = {
      device = "/dev/disk/by-uuid/7b63816f-d409-4fc3-878a-2b759ef4caad";
      preLVM = true;
    };
  };

  systemd.sleep.extraConfig = ''
    HibernateDelaySec=12h
  '';
  boot.resumeDevice = "/dev/disk/by-uuid/07e9aa38-3b22-4ddd-b519-d530ee5af17a";
  environment.systemPackages = [ pkgs.sbctl ];
  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/etc/secureboot";
  };
  boot.initrd.systemd.enable = true;

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
  # broken with linux 6.13
  hardware.framework.enableKmod = false;

  system.stateVersion = "23.05";
}
