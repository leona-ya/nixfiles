{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../profiles/base
    ../../profiles/desktop
    ../../services/int-acme-ca
    ../../services/paperless
    ../../services/bn-hass
    ./network.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.editor = false;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "zfs" ];
  boot.kernelParams = [
    "zfs.zfs_arc_max=6442450944"
    "zfs.zfs_arc_min=1024000000"
  ];
  networking.hostId = "d5714cb9";
  nix.distributedBuilds = false;
  services.nginx.defaultListenAddresses = [
    "0.0.0.0"
    "[::1]"
    "[fd8f:d15b:9f40:101::1312]"
  ];

  l.sops.secrets = {
    "profiles/desktop/alt_rsa_ssh_key".owner = "leona";
    "profiles/desktop/user_leona_pw".neededForUsers = true;
  };

  home-manager.users.leona.programs.ssh.extraConfig = ''
    IdentityFile ${config.sops.secrets."profiles/desktop/alt_rsa_ssh_key".path}
  '';
  users.users.leona.passwordFile = config.sops.secrets."profiles/desktop/user_leona_pw".path;
  security.sudo.wheelNeedsPassword = true;

  system.stateVersion = "23.05";
}
