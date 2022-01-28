{ config, pkgs, modulesPath, ... }:

{
  imports = [
      ./hardware-configuration.nix
      ./wireguard.nix
      ./network.nix
      ./initrd.nix
      ../../common
      ../../services/nextcloud
      ../../services/web
      ../../services/firefly-iii
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  services.qemuGuest.enable = true;

  em0lar.backups.enable = true;
  em0lar.telegraf = {
    enable = true;
    host = "[fd8f:d15b:9f40:c31:5054:ff:fee7:6ae5]";
    diskioDisks = [ "vda" ];
  };

  system.stateVersion = "21.05";
}
