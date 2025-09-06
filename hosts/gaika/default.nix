{
  lib,
  config,
  pkgs,
  ...
}:

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

  #  l.backups.enable = true;

  system.stateVersion = "22.11";
}
