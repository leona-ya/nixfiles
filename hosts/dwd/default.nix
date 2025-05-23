{ config, pkgs, lib, inputs, ... }:

{
  imports =
    [
      inputs.nixos-hardware.nixosModules.pcengines-apu
      ./hardware-configuration.nix
      ./network
    ];

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";

  networking.hostName = "dwd"; # to the honor of Donald Watts Davies
  networking.domain = "net.leona.is";

  #services.unifi.enable = true;
  #services.unifi.openFirewall = true;
  #services.unifi.unifiPackage = pkgs.unifi8;
  #services.unifi.mongodbPackage = pkgs.mongodb-6_0;

  networking.firewall.interfaces."br-lan".allowedTCPPorts = [ 8080 6789 8443 ];
  networking.firewall.interfaces."br-lan".allowedUDPPorts = [ 3478 10001 ];

  services.nginx.virtualHosts."${config.networking.hostName}.${config.networking.domain}" = {
    enableACME = lib.mkForce false;
    forceSSL = lib.mkForce false;
  };

  l.nginx-sni-proxy = {
    enable = true;
    upstreamHosts = {
      "thia.wg.net.leona.is" = [
        "hass.bn.leona.is"
      ];
    };
  };

  system.stateVersion = "21.05";
}
