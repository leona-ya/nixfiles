{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ../../common
      ./initrd.nix
      ./wireguard.nix
      ../../services/monitoring
      ../../services/dns/secondary
    ];

  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/sda";

  services.qemuGuest.enable = true;

  networking.hostName = "naiad";
  networking.domain = "ncp.nue.de.em0lar.dev";

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
    };
  };

  em0lar = {
    telegraf = {
      enable = true;
      host = "[fd8f:d15b:9f40:0c20::1]";
    };
  #  secrets = {
  #    "backup_ssh_key".owner = "root";
  #    "backup_passphrase".owner = "root";
  #  };
  #  backups = {
  #    enable = true;
  #    repo = "backup@helene.int.sig.de.labcode.de:/mnt/backup/repos/synced/naiad.ncp.nue.de.em0lar.dev";
  #  };
  };

  system.stateVersion = "21.05";
}


