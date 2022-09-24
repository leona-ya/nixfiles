{ config, pkgs, lib, inputs, ... }:

{
  imports = [
      ./hardware-configuration.nix
      ../../profiles/base
      ../../services/backup-relay
  ];
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "hack";
  networking.domain = "net.leona.is";
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
  nix.distributedBuilds = false;
  nix.settings.trusted-users = [ "nix-builder" ];
  users.users.nix-builder = {
    isSystemUser = true;
    shell = pkgs.bash;
    openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHgj7AC90pEBD0hHthE5BNobdfY+Uc2UJl+Ez5QL5PBo" ];
    group = "nix-builder";
  };
  users.groups.nix-builder = {};
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  l.telegraf = {
    enable = true;
    host = "[fd8f:d15b:9f40:c31:5054:ff:fe65:7a8e]";
    diskioDisks = [ "vda" ];
  };

  system.stateVersion = "22.05";
}
