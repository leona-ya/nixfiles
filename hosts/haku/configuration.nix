{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./wireguard.nix
      ../../common
      ../../services/dns/secondary
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "haku";
  networking.domain = "pbb.dus.de.em0lar.dev";
  boot.kernel.sysctl."net.ipv6.conf.all.forwarding" = true;
  boot.kernel.sysctl."net.ipv4.conf.all.forwarding" = true;

  networking.useDHCP = false;
  networking.interfaces.enp1s0.useDHCP = true;
  networking.useHostResolvConf = false;
  system.stateVersion = "20.09";

  em0lar.secrets = {
    "backup_ssh_key".owner = "root";
    "backup_passphrase".owner = "root";
  };
  em0lar.backups = {
    enable = true;
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
  services.nginx.virtualHosts."${config.networking.hostName}.${config.networking.domain}" = {
    enableACME = true;
    forceSSL = true;
    locations."/".proxyPass = "http://[fd8f:d15b:9f40:901::1]:8000";
  };
}


