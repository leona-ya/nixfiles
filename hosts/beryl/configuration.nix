{ config, pkgs, modulesPath, ... }:

{
  imports = [
      ./hardware-configuration.nix
      ./wireguard.nix
      ./network.nix
      ../../common
      ../../services/initrd-ssh
      ../../services/gitea
      ../../services/hedgedoc
      ../../services/matrix
      ../../services/vikunja
      #../../services/vouch-proxy
      ../../services/paperless-ng
      ../../services/vaultwarden
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  services.qemuGuest.enable = true;

  l.backups.enable = true;
  l.telegraf = {
    enable = true;
    host = "[fd8f:d15b:9f40:c31:5054:ff:fe4e:5cbf]";
    diskioDisks = [ "vda" ];
  };

  system.stateVersion = "21.05";
}
