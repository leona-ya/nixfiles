{ lib, config, ... }:
let
  hosthelper = import ../../../hosts { inherit lib config; };
in {
  imports = [
    ./dhcp.nix
  ];

  l.sops.secrets."hosts/charon/wireguard_wg-server_privatekey".owner = "systemd-network";
  l.sops.secrets."hosts/charon/wireguard_wg-public_privatekey".owner = "systemd-network";
  networking.firewall.allowedUDPPorts = [ 51441 ];

  systemd.network = {
    links."10-eth0" = {
      matchConfig.MACAddress = "a8:a1:59:8b:34:ee";
      linkConfig.Name = "eth0";
    };
    networks = {
      "10-eth0" = {
        DHCP = "yes";
        address = [ "2a01:4f9:6a:13c6::1/64" ];
        routes = [
          {
            routeConfig = {
              Destination = "::/0";
              Gateway = "fe80::1";
              GatewayOnLink = true;
            };
          }
        ];
        dns = [ "2a01:4f9:c010:3f02::1" ];
        matchConfig = {
          Name = "eth0";
        };
      };
      "05-br-internal" = {
        matchConfig = {
          Name = "br-internal";
        };
        address = [
          "10.151.20.254/24"
          "fd8f:d15b:9f40:0c41::1/64"
        ];
        networkConfig.ConfigureWithoutCarrier = true;
      };
      "05-br-internet" = {
        matchConfig = {
          Name = "br-internet";
        };
        address = [
          "100.64.0.254/24"
          "195.39.247.150/32"
          "2a01:4f9:6a:13c6:4000::1/66"
        ];
        routes = [
          { routeConfig = {
              Destination = "195.39.247.145";
              Scope = "link"; }; }
        ];
        networkConfig.ConfigureWithoutCarrier = true;
      };
      "30-wg-public" = {
        name = "wg-public";
        linkConfig = { RequiredForOnline = "yes"; };
        address = [ "195.39.247.150/32" ];
        routes = [ { routeConfig.Destination = "0.0.0.0/0"; } ];
      };
    } // hosthelper.groups.wireguard.g_systemd_network_networkconfig;
    netdevs = {
      "05-br-internal" = {
        netdevConfig = {
          Name = "br-internal";
          Kind = "bridge";
        };
      };
      "05-br-internet" = {
        netdevConfig = {
          Name = "br-internet";
          Kind = "bridge";
        };
      };
      "30-wg-public" = {
        netdevConfig = {
          Kind = "wireguard";
          Name = "wg-public";
        };
        wireguardConfig = {
          PrivateKeyFile = config.sops.secrets."hosts/charon/wireguard_wg-public_privatekey".path;
        };
        wireguardPeers = [{
          wireguardPeerConfig = {
            AllowedIPs = [
              "0.0.0.0/0"
            ];
            PublicKey = "aY/jNzJUjtohM2yoYSsDRnZyRppcxFHyw9AiDIV7cxQ=";
            Endpoint = "wg.net.leona.is:51440";
            PersistentKeepalive = 21;
          };
        }];
      };
    } //
     hosthelper.groups.wireguard.g_systemd_network_netdevconfig;
  };
  virtualisation.libvirtd.allowedBridges = [
    "br-internal"
    "br-internet"
  ];

  services.kresd.listenPlain = [
     "127.0.0.1:53"
     "[::1]:53"
     "10.151.20.254:53"
     "[fd8f:d15b:9f40:c41::1]:53"
   ];

  networking.firewall.interfaces = {
    "br-internal".allowedUDPPorts = [ 53 ];
    "br-internal".allowedTCPPorts = [ 53 ];
    "br-internet".allowedUDPPorts = [ 53 ];
    "br-internet".allowedTCPPorts = [ 53 ];
    "wg-server".allowedUDPPorts = [ 53 ];
    "wg-server".allowedTCPPorts = [ 53 ];
  };
  l.nftables = {
    extraForward = ''
      ct state invalid drop
      ct state established,related accept

      iifname br-internet oifname eth0 ct state new accept
      iifname eth0 oifname br-internet ct state new accept

      iifname br-internet oifname wg-public ct state new accept
      iifname wg-public oifname br-internet ct state new accept

      iifname wg-server oifname br-internal ct state new accept
      iifname br-internal oifname wg-server ct state new accept
    '';
    extraConfig = ''
      table ip nat {
        chain prerouting {
          type nat hook prerouting priority 0; policy accept;
        }

        chain postrouting {
          type nat hook postrouting priority 100; policy accept;
          ip saddr 100.64.0.0/24 oifname wg-public masquerade
        }
      }
    '';
  };
  boot.kernel.sysctl."net.ipv6.conf.all.forwarding" = true;
  boot.kernel.sysctl."net.ipv4.conf.all.forwarding" = true;
}
