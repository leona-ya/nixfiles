{ lib, config, ... }:
let
  hosthelper = import ../../../hosts { inherit lib config; };
in {
  imports = [
    ./dhcp.nix
  ];

  em0lar.sops.secrets."hosts/nyo/wireguard_wg-server_privatekey".owner = "systemd-network";
  networking.firewall.allowedUDPPorts = [ 51441 ];

  systemd.network = {
    links = {
      "10-eth0" = {
        matchConfig.MACAddress = "08:62:66:a4:5a:c6";
        linkConfig.Name = "eth0";
      };
    };
    networks = {
      "10-eth0" = {
        DHCP = "ipv4";
        matchConfig = {
          Name = "eth0";
        };
        address = [ "2a01:4f8:212:ad7::1/64" ];
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
      "05-br-nhp" = {
        matchConfig = {
          Name = "br-nhp";
        };
        address = [
          "10.151.20.254/24"
          "fd8f:d15b:9f40:0c31::1/64"
          "2a01:4f8:212:ad7:1000::1/68"
        ];
        networkConfig.ConfigureWithoutCarrier = true;
      };
    } // hosthelper.groups.wireguard.g_systemd_network_networkconfig;
    netdevs = {
      "05-br-nhp" = {
        netdevConfig = {
          Name = "br-nhp";
          Kind = "bridge";
        };
      };
    } // hosthelper.groups.wireguard.g_systemd_network_netdevconfig;
  };
  virtualisation.libvirtd.allowedBridges = [
    "virbr0"
    "br-nhp"
  ];

  em0lar.nftables = {
    extraForward = ''
      ct state invalid drop
      ct state established,related accept

      iifname br-nhp oifname eth0 ct state new accept
      iifname eth0 oifname br-nhp ct state new accept

      iifname wg-server oifname br-nhp ct state new accept
      iifname br-nhp oifname wg-server ct state new accept
    '';
    extraConfig = ''
      table ip nat {
        chain prerouting {
          type nat hook prerouting priority 0; policy accept;
        }

        chain postrouting {
          type nat hook postrouting priority 100; policy accept;
          oifname eth0 masquerade
        }
      }
    '';
  };
  boot.kernel.sysctl."net.ipv6.conf.all.forwarding" = true;
  boot.kernel.sysctl."net.ipv4.conf.all.forwarding" = true;
}
