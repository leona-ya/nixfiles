{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./wireguard.nix
      ../../common
      ../../services/dns-knot/secondary
      ../../services/dns-kresd
    ];

  # Secondary DNS
  services.knot.extraConfig = ''
    server:
      listen: 127.0.0.11@53
      listen: 195.39.247.188@53
      listen: 2a0f:4ac0:0:1::d25@53
  '';
  services.kresd.listenPlain = [
     "127.0.0.1:53"
     "[::1]:53"
     "10.151.9.1:53"
     "[fd8f:d15b:9f40:c00::1]:53"
   ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.editor = false;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "haku";
  networking.domain = "net.leona.is";
  boot.kernel.sysctl."net.ipv6.conf.all.forwarding" = true;
  boot.kernel.sysctl."net.ipv4.conf.all.forwarding" = true;

  networking.useDHCP = false;
  networking.interfaces.enp1s0.useDHCP = true;
  networking.useHostResolvConf = false;

  systemd.network = {
    links."10-eth0" = {
      matchConfig.MACAddress = "52:54:00:e3:fc:60";
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

  l.backups = {
    enable = true;
  };
  l.telegraf = {
    enable = true;
    host = "[fd8f:d15b:9f40:0c00::1]";
    extraInputs = {
      wireguard = {
        devices = [
          "wg-public"
          "wg-server"
        ];
      };
    };
    diskioDisks = [ "vda" ];
  };
  systemd.services.telegraf.serviceConfig.AmbientCapabilities = [ "CAP_NET_ADMIN" ];
  services.nginx.virtualHosts."${config.networking.hostName}.${config.networking.domain}" = {
    enableACME = true;
    forceSSL = true;
    locations."/".proxyPass = "http://[fd8f:d15b:9f40:901::1]:8000";
  };

  system.stateVersion = "20.09";
}


