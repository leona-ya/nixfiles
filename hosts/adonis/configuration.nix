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
    };

    netdevs."30-wg-server" = {
      netdevConfig = {
        Kind = "wireguard";
        Name = "wg-server";
      };
      wireguardConfig = {
        PrivateKeyFile = config.em0lar.secrets."wireguard_wg-server_privatekey".path;
        ListenPort = 51441;
      };
      wireguardPeers = [
        { # dwd
          wireguardPeerConfig = {
            AllowedIPs = [
              "fd8f:d15b:9f40::/53"
            ];
            PublicKey = "8Jzx9hklD8g6colimGybv9kpC2q0oTIgrISGhLd0QEM=";
            PersistentKeepalive = 21;
          };
        }
        {
          wireguardPeerConfig = {
            AllowedIPs = [ "fd8f:d15b:9f40::/48" ];
            PublicKey = "376YjLMEUFHWFE5Xkn3qRyIQ/kAHzM4DhvIcC5boCQ8=";
            Endpoint = "wg.net.em0lar.dev:51441";
          };
        }
      ];
    };
    networks."30-wg-server" = {
      name = "wg-server";
      linkConfig = { RequiredForOnline = "yes"; };
      address = [ "fd8f:d15b:9f40:0c10::1/72" ];
      routes = [
        { routeConfig.Destination = "fd8f:d15b:9f40::/48"; }
      ];
    };
  };
  em0lar.secrets."wireguard_wg-server_privatekey".owner = "systemd-network";
  networking.firewall.allowedUDPPorts = [ 51441 ];

  networking.hostName = "adonis";
  networking.domain = "net.em0lar.dev";
}
