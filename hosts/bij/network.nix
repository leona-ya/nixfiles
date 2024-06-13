{ config, lib, ... }:

let
  hosthelper = import ../../hosts/helper.nix { inherit lib config; };
in
{
  l.sops.secrets."hosts/bij/wireguard_wg-clients_privatekey".owner = "systemd-network";
  l.sops.secrets."hosts/bij/wireguard_wg-server_privatekey".owner = "systemd-network";
  l.sops.secrets."hosts/bij/wireguard_wg-public-in_privatekey".owner = "systemd-network";
  l.sops.secrets."hosts/bij/wireguard_wg-public-out_privatekey".owner = "systemd-network";
  networking.firewall.allowedUDPPorts = [ 4500 51440 51441 ];

  networking.hostName = "bij";
  networking.domain = "net.leona.is";
  systemd.network = {
    links = {
      "10-eth0" = {
        matchConfig.MACAddress = "96:00:02:39:ff:65";
        linkConfig.Name = "eth0";
      };
      "10-eth-nat" = {
        matchConfig.MACAddress = "86:00:00:49:49:ab";
        linkConfig.Name = "eth-nat";
      };
    };
    netdevs = {
      "30-wg-public-in" = {
        netdevConfig = {
          Kind = "wireguard";
          Name = "wg-public-in";
        };
        wireguardConfig = {
          PrivateKeyFile = config.sops.secrets."hosts/bij/wireguard_wg-public-in_privatekey".path;
        };
        wireguardPeers = [{
          AllowedIPs = [
            "0.0.0.0/0"
            "::/0"
          ];
          PublicKey = "kih/GnR4Bov/DM/7Rd21wK+PFQRUNH6sywVuNKkUAkk=";
          Endpoint = "[2a0f:4ac0:ca6c::1]:51820";
          PersistentKeepalive = 21;
        }];
      };
      "30-wg-public-out" = {
        netdevConfig = {
          Kind = "wireguard";
          Name = "wg-public-out";
        };
        wireguardConfig = {
          PrivateKeyFile = config.sops.secrets."hosts/bij/wireguard_wg-public-out_privatekey".path;
          ListenPort = 51440;
        };
        wireguardPeers = [
          {
            AllowedIPs = [
              "195.39.247.148/32"
              "2a0f:4ac0:1e0:100::1/60"
            ];
            PublicKey = "jG5oAuO9PHsMHwzyEbX2y3aBYcs6A24DbxvoNcRtZhc=";
            PersistentKeepalive = 21;
          }
          {
            AllowedIPs = [
              "195.39.247.151/32"
              "2a0f:4ac0:1e0:20::1/60"
            ];
            PublicKey = "3SB96yLcWFrEpGPzeLGhPaDyDOmQj5uLLAPL2Mo9jQs=";
            PersistentKeepalive = 21;
          }
        ];
      };
    } // hosthelper.groups.wireguard.g_systemd_network_netdevconfig;
    networks = {
      "10-eth0" = {
        DHCP = "yes";
        matchConfig = {
          Name = "eth0";
        };
        address = [
          "2a01:4f8:c010:1098::1/64"
        ];
        routes = [
          { Destination = "::/0"; Gateway = "fe80::1"; GatewayOnLink = true; }
        ];
      };
      "10-eth-nat" = {
        matchConfig.Name = "eth-nat";
        address = [ "10.62.41.2/32" ];
        routes = [
          { Destination = "10.62.41.0/24"; Gateway = "10.62.41.1"; GatewayOnLink = true; }
        ];
      };
      "30-wg-public-in" = {
        name = "wg-public-in";
        linkConfig = { RequiredForOnline = "yes"; };
        address = [ ];
        routes = [
          {
            Destination = "::/0";
            Table = 30;
          }
          {
            Destination = "0.0.0.0/0";
            Table = 30;
          }
        ];
      };
      "30-wg-public-out" = {
        name = "wg-public-out";
        linkConfig = { RequiredForOnline = "no"; };
        address = [ ];
        routes = [
          { Destination = "195.39.247.144/28"; }
          { Destination = "2a0f:4ac0:1e0::/48"; }
        ];
        routingPolicyRules = [
          {
            Family = "ipv4";
            Table = 30;
            From = "195.39.247.144/28";
          }
          {
            Family = "ipv6";
            Table = 30;
            From = "2a0f:4ac0:1e0::/48";
          }
        ];
      };
    } // hosthelper.groups.wireguard.g_systemd_network_networkconfig;
  };
  networking.firewall.extraForwardRules = ''
    ct state invalid drop
    ct state established,related accept

    iifname eth-nat oifname eth0 ct state new accept
    iifname wg-clients oifname wg-clients ct state new accept
    iifname wg-clients oifname wg-server ct state new accept
    iifname wg-server oifname wg-server ct state new accept
    iifname wg-server oifname wg-clients ct state new accept
    iifname wg-public-out oifname wg-public-out ct state new accept
    iifname wg-public-out oifname wg-public-in ct state new accept
    iifname wg-public-in oifname wg-public-out ct state new accept
  '';
  networking.nat = {
    enable = true;
    externalInterface = "eth0";
    internalInterfaces = [ "eth-nat" ];
  };

  boot.kernel.sysctl."net.ipv6.conf.all.forwarding" = true;
  boot.kernel.sysctl."net.ipv4.conf.all.forwarding" = true;
  networking.useHostResolvConf = false;
}
