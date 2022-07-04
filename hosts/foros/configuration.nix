{ config, pkgs, modulesPath, ... }:

{
  imports = [
      ./hardware-configuration.nix
      ./wireguard.nix
      ./network.nix
      ../../common
      ../../services/initrd-ssh
      ../../services/nextcloud
      ../../services/web
      ../../services/firefly-iii
      ../../services/grocy
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  services.qemuGuest.enable = true;

  l.backups.enable = true;
  l.telegraf = {
    enable = true;
    host = "[fd8f:d15b:9f40:c31:5054:ff:fee7:6ae5]";
    diskioDisks = [ "vda" ];
  };

  services.postgresql.package = pkgs.postgresql_14;

  system.stateVersion = "21.05";
}
