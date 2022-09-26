{ config, pkgs, modulesPath, lib, ... }:

{
  imports = [
      ./hardware-configuration.nix
      ../../profiles/base
      ../../profiles/zfs-nopersist
      ../../services/ldap
      ../../services/keycloak
      ../../services/hydra-sso
  ];
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = ["zfs"];
  boot.zfs.devNodes = "/dev/disk/by-path";
  boot.kernelParams = [
    "zfs.zfs_arc_max=1024000000"
  ];
  networking.hostId = "da2123a2";

  networking.hostName = "ladon";
  networking.domain = "net.leona.is";
  systemd.network = {
    links."10-eth-internal" = {
      matchConfig.MACAddress = "52:54:00:a0:d5:2c";
      linkConfig.Name = "eth-internal";
    };
    networks."10-eth-internal" = {
      DHCP = "yes";
      matchConfig = {
        Name = "eth-internal";
      };
    };

    links."10-eth-internet" = {
      matchConfig.MACAddress = "52:54:00:95:2b:ad";
      linkConfig.Name = "eth-internet";
    };
    networks."10-eth-internet" = {
      DHCP = "yes";
      matchConfig = {
        Name = "eth-internet";
      };
    };
  };

  networking.useHostResolvConf = false;
  l.nftables.checkIPTables = false;
  l.backups.enable = true;
  l.telegraf = {
    enable = true;
    host = "[fd8f:d15b:9f40:c41:5054:ff:fea0:d52c]";
    diskioDisks = [ "vda" ];
  };

  services.postgresql.package = pkgs.postgresql_14;

  system.stateVersion = "22.11";
}
