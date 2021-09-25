{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ../../common
      ./initrd.nix
      ./wireguard.nix
      ../../services/dns-kresd
      ../../services/dns-knot/primary
      ../../services/mail
     ../../services/convos
    ];

  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/sda";

  services.qemuGuest.enable = true;

  networking.hostName = "myron";
  networking.domain = "net.em0lar.dev";

  systemd.network = {
    links."10-eth0" = {
      matchConfig.MACAddress = "96:00:00:a6:9f:d0";
      linkConfig.Name = "eth0";
    };
    networks."10-eth0" = {
      DHCP = "ipv4";
      matchConfig = {
        Name = "eth0";
      };
      address = [ "2a01:4f9:c010:beb5::1/64" ];
      routes = [
        {
          routeConfig = {
            Destination = "::/0";
            Gateway = "fe80::1";
            GatewayOnLink = true;
          };
        }
      ];
    };
  };

  em0lar.telegraf = {
    enable = true;
    host = "[fd8f:d15b:9f40:0c21::1]";
    diskioDisks = [ "sda" "sdb" ];
  };
  em0lar.backups.enable = true;

  system.stateVersion = "21.05";
}


