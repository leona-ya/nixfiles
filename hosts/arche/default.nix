{ config, pkgs, lib, inputs, ... }:

{
  imports =
    [
      inputs.disko.nixosModules.disko
      ./disko.nix
      ./hardware-configuration.nix
      ./network
    ];
  deployment.targetHost = "10.42.10.205";

  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.editor = false;
  boot.loader.efi.canTouchEfiVariables = true;

  services.nginx.virtualHosts."${config.networking.hostName}.${config.networking.domain}" = {
    enableACME = lib.mkForce false;
    forceSSL = lib.mkForce false;
  };
#  l.telegraf = {
#    enable = true;
#    host = "[fd8f:d15b:9f40:100::1]";
#    diskioDisks = [ "sda" ];
#    extraInputs = {
#      sensors = { };
#      prometheus = [{
#        urls = [ "http://10.151.5.20/metrics" ];
#      }];
#    };
#  };
#  services.telegraf.extraConfig.inputs.net.interfaces = [ "eth0" "br*" "ppp-wan" "wg-server" ];
#  systemd.services.telegraf.path = [ pkgs.lm_sensors ];

#  l.promtail = {
#    enable = true;
#    enableNginx = true;
#  };
#
#  l.nginx-sni-proxy = {
#    enable = true;
#    upstreamHosts = {
#      "thia.wg.net.leona.is" = [
#        "hass.bn.leona.is"
#      ];
#    };
#  };

  system.stateVersion = "25.05";
}
