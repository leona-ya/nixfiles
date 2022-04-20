{ config, pkgs, modulesPath, lib, ... }:

{
  imports = [
      ./hardware-configuration.nix
      ./wireguard.nix
      ../../common
      ../../services/initrd-ssh
      ../../services/hedgedoc
      ../../services/paperless
      ../../services/vaultwarden
      ../../services/vikunja
  ];
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "laurel";
  networking.domain = "net.leona.is";
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
      networkConfig.IPv6PrivacyExtensions = "no";
    };
  };
  networking.useHostResolvConf = false;
  l.nftables.checkIPTables = false;
  l.backups.enable = true;
  l.telegraf = {
    enable = true;
    host = "[fd8f:d15b:9f40:c31:5054:ff:fe68:7591]";
    diskioDisks = [ "vda" ];
  };

  services.nginx.virtualHosts."${config.networking.hostName}.${config.networking.domain}" = {
    enableACME = lib.mkForce false;
    forceSSL = lib.mkForce false;
  };

  system.stateVersion = "21.05";
}
