{
  config,
  lib,
  inputs,
  pkgs,
  ...
}:

{
  imports = [
    inputs.disko.nixosModules.disko
    # ToDo
    # inputs.nixos-hardware.nixosModules.lenovo-thinkpad-x1-14thgen
    ./hardware-configuration.nix
    ./disko.nix
    ../../profiles/desktop
    ../../profiles/desktop/sway
    ./network.nix
    ./kanshi.nix
    #./wireguard.nix
  ];

  deployment.allowLocalDeployment = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.editor = false;
  boot.loader.efi.canTouchEfiVariables = true;

  #systemd.sleep.extraConfig = ''
  #  HibernateDelaySec=48h
  #'';
  #boot.resumeDevice = "/dev/disk/by-uuid/07e9aa38-3b22-4ddd-b519-d530ee5af17a";
  #
  l.meta.bootstrap = true;

  l.sops.secrets = {
    "profiles/desktop/user_leona_pw".neededForUsers = true;
  };

  services.upower = {
    enable = true;
    percentageLow = 10;
    percentageCritical = 7;
    percentageAction = 5;
  };
  systemd.services.upower.wantedBy = lib.mkForce [ "multi-user.target" ];

  services.fprintd.enable = true;
  # Needed for desktop environments to detect/manage display brightness. TODO: check!
  hardware.sensor.iio.enable = lib.mkDefault true;

  users.users.leona.hashedPasswordFile = config.sops.secrets."profiles/desktop/user_leona_pw".path;
  security.sudo-rs.wheelNeedsPassword = true;

  system.stateVersion = "26.05";
}
