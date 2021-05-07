{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./wireguard.nix
      #./nat.nix
      ../../common
      ../../services/dns/secondary
    ];

  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.efiSupport = true;
  # boot.loader.grub.efiInstallAsRemovable = true;
  # boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # Define on which hard drive you want to install Grub.
  boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only

  networking.hostName = "rechaku";
  networking.domain = "het.fks.de.em0lar.dev";
  boot.kernel.sysctl."net.ipv6.conf.all.forwarding" = true;
  boot.kernel.sysctl."net.ipv4.conf.all.forwarding" = true;

  networking.useHostResolvConf = false;
  system.stateVersion = "20.09";
  systemd.network = {
    links."10-eth0" = {
      matchConfig.MACAddress = "96:00:00:b2:63:89";
      linkConfig.Name = "eth0";
    };
    networks."10-eth0" = {
      DHCP = "ipv4";
      matchConfig = {
        Name = "eth0";
      };
      address = [ "2a01:4f8:c17:235a::1/128" ];
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
    host = "[fd8f:d15b:9f40:0c00::1]";
    extraInputs = {
      wireguard = {
        devices = [
          "wg-public"
          "wg-server"
        ];
      };
    };
  };
  systemd.services.telegraf.serviceConfig.AmbientCapabilities = [ "CAP_NET_ADMIN" ];
}


