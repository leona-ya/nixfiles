{ config, pkgs, lib, inputs, ... }:

{
  imports = [
      ./hardware-configuration.nix
      ../../profiles/base
#      ../../services/backup-relay
  ];
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = ["zfs"];
  boot.zfs.devNodes = "/dev/disk/by-path";
  networking.hostId = "046fab2e";

  networking.hostName = "hack";
  networking.domain = "net.leona.is";
  systemd.network = {
      links."10-eth-internal" = {
        matchConfig.MACAddress = "52:54:00:ef:6d:c3";
        linkConfig.Name = "eth-internal";
      };
      networks."10-eth-internal" = {
        DHCP = "yes";
        matchConfig.Name = "eth-internal";
      };

    links."10-eth-internet" = {
      matchConfig.MACAddress = "52:54:00:30:e4:b5";
      linkConfig.Name = "eth-internet";
    };
    networks."10-eth-internet" = {
      DHCP = "yes";
      matchConfig.Name = "eth-internet";
    };
  };

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
    host = "[fd8f:d15b:9f40:c41:5054:ff:feef:6dc3]";
    diskioDisks = [ "vda" ];
  };

  system.stateVersion = "22.11";
}
