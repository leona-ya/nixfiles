{ config, pkgs, lib, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ../../common
      ./network
    ];

  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/sda";

  networking.hostName = "dwd"; # to the honor of Donald Watts Davies
  networking.domain = "int.sig.de.em0lar.dev";

  system.stateVersion = "21.05";

  services.nginx.virtualHosts."${config.networking.hostName}.${config.networking.domain}" = {
    enableACME = lib.mkForce false;
    forceSSL = lib.mkForce false;
  };
  em0lar.telegraf = {
    enable = true;
    host = "[fd8f:d15b:9f40::1]";
    diskioDisks = [ "sda" ];
  };
  services.telegraf.extraConfig.inputs.net.interfaces = [ "br*" "ppp-wan" ];
}
