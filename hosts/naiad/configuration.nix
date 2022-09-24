{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ../../profiles/base
      ./initrd.nix
      ./wireguard.nix
      ../../services/monitoring
      ../../services/dns-knot/secondary
    ];

  # Secondary DNS
  services.knot.extraConfig = ''
    server:
      listen: 127.0.0.11@53
      listen: 37.120.184.164@53
      listen: 2a03:4000:f:85f::1@53
      listen: fd8f:d15b:9f40:c20::1@53
  '';

  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/sda";

  services.qemuGuest.enable = true;

  networking.hostName = "naiad";
  networking.domain = "net.leona.is";

  systemd.network = {
    links."10-eth0" = {
      matchConfig.MACAddress = "4a:2c:e5:e4:2d:38";
      linkConfig.Name = "eth0";
    };
    networks."10-eth0" = {
      DHCP = "ipv4";
      matchConfig = {
        Name = "eth0";
      };
      address = [ "2a03:4000:f:85f::1/64" ];
      routes = [
        {
          routeConfig = {
            Destination = "::/0";
            Gateway = "fe80::1";
            GatewayOnLink = true;
          };
        }
      ];
      networkConfig.IPv6PrivacyExtensions = "no";
    };
  };

  l.telegraf = {
    enable = true;
    host = "[fd8f:d15b:9f40:0c20::1]";
    diskioDisks = [ "sda" ];
  };

  l.backups.enable = true;

  system.stateVersion = "21.05";
}


