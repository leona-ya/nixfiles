{ config, pkgs, lib, inputs, ... }:

{
  imports = [
      ./hardware-configuration.nix
      ../../common
      ../../services/backup-relay
  ];
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "hack";
  networking.domain = "net.em0lar.dev";
  services.resolved.dnssec = "false"; # dnssec check is already done on other dns server
  systemd.network = {
    links."10-eth" = {
        matchConfig.MACAddress = "52:54:00:65:7a:8e";
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
  networking.useDHCP = false;

  nix.gc.automatic = false;
  environment.systemPackages = [ inputs.deploy-rs.defaultPackage.x86_64-linux ];
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  em0lar.telegraf = {
    enable = true;
    host = "[fd8f:d15b:9f40:c31:5054:ff:fe65:7a8e]";
    diskioDisks = [ "vda" ];
  };

  system.stateVersion = "22.05";
}
