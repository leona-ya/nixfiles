
{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./wireguard.nix
      ../../common
    ];

  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.efiSupport = true;
  # boot.loader.grub.efiInstallAsRemovable = true;
  # boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # Define on which hard drive you want to install Grub.
  boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only

  networking.hostName = "rechaku";
  networking.domain = "net.em0lar.dev";
  boot.kernel.sysctl."net.ipv6.conf.all.forwarding" = true;
  boot.kernel.sysctl."net.ipv4.conf.all.forwarding" = true;

  networking.useHostResolvConf = false;
  systemd.network = {
    links."10-ens3" = {
      linkConfig.Name = "ens3";
    };
    networks."10-ens3" = {
      DHCP = "ipv4";
      matchConfig = {
        Name = "ens3";
      };
      address = [ "2a01:4f8:c010:9e88::1/128" ];
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
  system.stateVersion = "21.05";
}

