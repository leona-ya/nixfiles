{ config, pkgs, modulesPath, lib, ... }:

{
  imports = [
      ./hardware-configuration.nix
      ./initrd.nix
      ../../common
      ../../services/ldap
      ../../services/keycloak
  ];
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "ladon";
  networking.domain = "net.em0lar.dev";
  services.resolved.dnssec = "false"; # dnssec check is already done on other dns server
  systemd.network = {
    links."10-eth0" = {
      matchConfig.MACAddress = "52:54:00:d2:a7:92";
      linkConfig.Name = "eth0";
    };
    networks."10-eth0" = {
      DHCP = "yes";
      matchConfig = {
        Name = "eth0";
      };
    };
  };
  networking.useHostResolvConf = false;
  em0lar.nftables.checkIPTables = false;

  em0lar = {
    backups.enable = true;
    telegraf = {
      enable = true;
      host = "[fd8f:d15b:9f40:c32:5054:ff:fed2:a792]";
      diskioDisks = [ "sda" ];
    };
  };
  services.nginx.virtualHosts."${config.networking.hostName}.${config.networking.domain}" = {
    enableACME = lib.mkForce false;
    forceSSL = lib.mkForce false;
  };

  system.stateVersion = "21.05";
}
