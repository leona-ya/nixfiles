{ lib, config, pkgs, ... }:

{
  imports = [
      ./hardware-configuration.nix
      ./wireguard.nix
      ./network.nix
      ../../common
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  services.nginx.virtualHosts."${config.networking.hostName}.${config.networking.domain}" = {
    enableACME = lib.mkForce false;
    forceSSL = lib.mkForce false;
  };

#  services.qemuGuest.enable = true;

#  l.backups.enable = true;
  l.telegraf = {
    enable = true;
    host = "[fd8f:d15b:9f40:10:11:32ff:fe2a:888e]";
    diskioDisks = [ "vda" ];
  };

  system.stateVersion = "22.11";
}
