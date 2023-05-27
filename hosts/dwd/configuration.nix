{ config, pkgs, lib, inputs, ... }:

{
  imports =
    [
      inputs.nixos-hardware.nixosModules.pcengines-apu
      ./hardware-configuration.nix
      ./network
    ];

  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/sda";

  networking.hostName = "dwd"; # to the honor of Donald Watts Davies
  networking.domain = "net.leona.is";

  services.unifi.enable = true;
  services.unifi.openFirewall = true;
  services.unifi.unifiPackage = pkgs.unifi;
  l.nftables.extraInput = ''
	  iifname br-lan tcp dport { 8080, 6789, 8443 } accept
    iifname br-lan udp dport { 3478, 10001 } accept
  '';

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
