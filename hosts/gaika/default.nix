{ lib, config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./wireguard.nix
    ./network.nix
  ];

  deployment.targetHost = "gaika.wg.net.leona.is";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  services.nginx.enable = false;
  services.nginx.virtualHosts."gaika.net.leona.is".enableACME = false;
  #  services.qemuGuest.enable = true;

  l.promtail = {
    enable = true;
    enableNginx = true;
  };
  #  l.backups.enable = true;
  l.telegraf = {
    enable = true;
    host = "[fd8f:d15b:9f40:10:11:32ff:fe2a:888e]";
    diskioDisks = [ "vda" ];
  };

  system.stateVersion = "22.11";
}
