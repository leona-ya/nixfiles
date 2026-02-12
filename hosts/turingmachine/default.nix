{
  config,
  lib,
  inputs,
  pkgs,
  ...
}:

{
  imports = [
    inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t480s
    ./hardware-configuration.nix
    ../../profiles/desktop
    ../../profiles/desktop/sway
    ./network.nix
    ./wireguard.nix
    ./kanshi.nix
  ];

  deployment.allowLocalDeployment = true;
  deployment.targetHost = "fd8f:d15b:9f40:901::1";

  l.meta.bootstrap = true;
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.editor = false;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "zfs" ];
  boot.kernelPackages = lib.mkForce pkgs.linuxPackages;
  boot.kernelParams = [
    "zfs.zfs_arc_max=2048000000"
    "zfs.zfs_arc_min=1024000000"
  ];
  networking.hostId = "a4232228";

  l.sops.secrets = {
    "profiles/desktop/alt_rsa_ssh_key".owner = "leona";
    "profiles/desktop/user_leona_pw".neededForUsers = true;
  };

  services.nginx.enable = false;
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

  system.stateVersion = "20.09";
}
