{ config, pkgs, modulesPath, lib, ... }:

{
  imports = [
      ./hardware-configuration.nix
      ../../common
      ../../services/ldap
      ../../services/keycloak
  ];

  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/sda";

  environment.noXlibs = lib.mkForce false;
  networking.hostName = "ladon";
  networking.domain = "net.em0lar.dev";
  services.resolved.dnssec = "false"; # dnssec check is already done on other dns server
  systemd.network = {
    links."10-eth0" = {
      matchConfig.MACAddress = "6e:f2:ec:90:8c:3c";
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
  networking.firewall.interfaces.eth0.allowedTCPPorts = [ 389  636 ];

  em0lar = {
    backups.enable = true;
    telegraf = {
      enable = true;
      host = "[fd8f:d15b:9f40:11:6cf2:ecff:fe90:8c3c]";
      diskioDisks = [ "sda" ];
    };
  };
  services.nginx.virtualHosts."${config.networking.hostName}.${config.networking.domain}" = {
    enableACME = lib.mkForce false;
    forceSSL = lib.mkForce false;
  };

  system.stateVersion = "21.05";
}
