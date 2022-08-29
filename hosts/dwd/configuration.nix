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
  networking.domain = "net.leona.is";

  services.nginx.virtualHosts."${config.networking.hostName}.${config.networking.domain}" = {
    enableACME = lib.mkForce false;
    forceSSL = lib.mkForce false;
  };
  l.telegraf = {
    enable = true;
    host = "[fd8f:d15b:9f40:100::1]";
    diskioDisks = [ "sda" ];
    extraInputs = {
      sensors = { };
      prometheus = [{
        urls = ["http://10.151.5.20/metrics"];
      }];
    };
  };
  services.telegraf.extraConfig.inputs.net.interfaces = [ "eth0" "br*" "ppp-wan" "wg-server" ];
  systemd.services.telegraf.path = [ pkgs.lm_sensors ];

  system.stateVersion = "21.05";
}
