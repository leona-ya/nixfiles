{ config, lib, inputs, pkgs, ... }:

{
  imports = [
#    inputs.nixos-hardware.nixosModules.framework-7040-amd
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
  security.sudo.wheelNeedsPassword = true;

  home-manager.users.leona = {
    programs.ssh.extraConfig = ''
      IdentityFile ${config.sops.secrets."profiles/desktop/alt_rsa_ssh_key".path}
    '';
  };

#  l.backups = {
#    enable = true;
#    excludes = [
#      "/var/cache"
#      "/var/lock"
#      "/var/spool"
#      "/var/log"
#      "/home/leona/.local/share/containers"
#      "/home/leona/sync/nas"
#      "/var/lib/containers"
#      "**/node_modules"
#      "**/.venv"
#      "**/target"
#      "/home/*/.cache"
#      "/home/*/.rustup"
#      "**/Cache"
#    ];
#    enableSystemdTimer = false;
#  };

  # nixos-hardware

  # AMD has better battery life with PPD over TLP:
  # https://community.frame.work/t/responded-amd-7040-sleep-states/38101/13
  services.power-profiles-daemon.enable = lib.mkDefault true;

  # Fix TRRS headphones missing a mic
  # https://community.frame.work/t/headset-microphone-on-linux/12387/3
  boot.extraModprobeConfig = ''
    options snd-hda-intel model=dell-headset-multi
  '';

  # For fingerprint support
  services.fprintd.enable = lib.mkDefault true;

  # Custom udev rules
  services.udev.extraRules = ''
    # Ethernet expansion card support
    ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="0bda", ATTR{idProduct}=="8156", ATTR{power/autosuspend}="20"
  '';

  # Needed for desktop environments to detect/manage display brightness
  hardware.sensor.iio.enable = lib.mkDefault true;

  # imports
  boot.kernelParams = [ "amd_pstate=active" ];
  hardware.opengl = {
    driSupport = lib.mkDefault true;
    driSupport32Bit = lib.mkDefault true;
  };

  system.stateVersion = "23.05";
}
