{ config, pkgs, modulesPath, ... }:

{
  imports = [
      ./hardware-configuration.nix
      ./wireguard.nix
      ./network.nix
      ../../common
      ../../services/gitea
      ../../services/hedgedoc
      ../../services/matrix
      ../../services/vikunja
  ];

  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/sda";

  services.qemuGuest.enable = true;

  em0lar.backups.enable = true;
  em0lar.telegraf = {
    enable = true;
    host = "[fd8f:d15b:9f40:11:8079:3aff:fe35:9ddc]";
    diskioDisks = [ "sda" ];
  };

  system.stateVersion = "21.05";
}
