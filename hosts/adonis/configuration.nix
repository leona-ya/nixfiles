{ config, pkgs, lib, inputs, ... }:

{
  imports = [
      ./hardware-configuration.nix
      ./initrd.nix
      ../../common
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  systemd.network = {
    links."10-eth0" = {
      matchConfig.MACAddress = "02:00:17:09:4c:66";
      linkConfig.Name = "eth0";
    };
    networks."10-eth0" = {
      DHCP = "yes";
      matchConfig = {
        Name = "eth0";
      };
      #address = [ "2a01:4f9:c010:beb5::1/64" ];
      #routes = [
      #  {
      #    routeConfig = {
      #      Destination = "::/0";
      #      Gateway = "fe80::1";
      #      GatewayOnLink = true;
      #    };
      #  }
      #];
    };
  };

  networking.hostName = "adonis";
  networking.domain = "net.em0lar.dev";
}
