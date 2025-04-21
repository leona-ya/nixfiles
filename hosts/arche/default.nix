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
