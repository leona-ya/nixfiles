{ lib, config, ... }:
let
  hosthelper = import ../../../hosts { inherit lib config; };
in {
  imports = [
    ./dhcp.nix
  ];

  l.sops.secrets."hosts/nyan/wireguard_wg-server_privatekey".owner = "systemd-network";
  l.sops.secrets."hosts/nyan/wireguard_wg-public-bkp_privatekey".owner = "systemd-network";
  networking.firewall.allowedUDPPorts = [ 51441 ];

  systemd.network = {
    links = {
      "10-eth0" = {
        matchConfig.MACAddress = "a8:a1:59:36:6a:f2";
        linkConfig.Name = "eth0";
      };
    };
    networks = {
      "10-eth0" = {
        DHCP = "ipv4";
        matchConfig = {
          Name = "eth0";
        };
        address = [ "2a01:4f8:242:155f::1/64" ];
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
          "2a01:4f8:242:155f:1000::1/68"
        ];
        networkConfig.ConfigureWithoutCarrier = true;
        networkConfig.IPv6PrivacyExtensions = "no";
      };
      "05-br-nh" = {
        matchConfig = {
          Name = "br-nh";
        };
        address = [
          "10.151.21.62/26"
          "fd8f:d15b:9f40:0c32::1/64"
          "2a01:4f8:242:155f:2000::1/68"
        ];
        networkConfig.ConfigureWithoutCarrier = true;
        networkConfig.IPv6PrivacyExtensions = "no";
      };
      "05-br-n" = {
        matchConfig = {
          Name = "br-n";
        };
        address = [
          "10.151.21.126/26"
          "2a01:4f8:242:155f:3000::1/68"
        ];
        networkConfig.ConfigureWithoutCarrier = true;
      };
      "05-br-np" = {
        matchConfig = {
          Name = "br-np";
        };
        address = [
          "10.151.21.192/26"
          "2a01:4f8:242:155f:4000::1/68"
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
      "05-br-nh" = {
        netdevConfig = {
          Name = "br-nh";
          Kind = "bridge";
        };
      };
      "05-br-n" = {
        netdevConfig = {
          Name = "br-n";
          Kind = "bridge";
        };
      };
      "05-br-np" = {
        netdevConfig = {
          Name = "br-np";
          Kind = "bridge";
        };
      };
    } //
     hosthelper.groups.wireguard.g_systemd_network_netdevconfig;
  };
  virtualisation.libvirtd.allowedBridges = [
    "virbr0"
    "br-nhp"
    "br-nh"
    "br-n"
    "br-np"
  ];

  services.kresd.listenPlain = [
     "127.0.0.1:53"
     "[::1]:53"
     "10.151.20.254:53"
     "[2a01:4f8:242:155f:1000::1]:53"
     "10.151.21.62:53"
     "[2a01:4f8:242:155f:2000::1]:53"
     "10.151.21.126:53"
     "[2a01:4f8:242:155f:3000::1]:53"
     "10.151.21.192:53"
     "[2a01:4f8:242:155f:4000::1]:53"
   ];

  networking.firewall.interfaces = {
    "br-nhp".allowedUDPPorts = [ 53 ];
    "br-nhp".allowedTCPPorts = [ 53 ];
    "br-nh".allowedUDPPorts = [ 53 ];
    "br-nh".allowedTCPPorts = [ 53 ];
    "br-n".allowedUDPPorts = [ 53 ];
    "br-n".allowedTCPPorts = [ 53 ];
    "br-np".allowedUDPPorts = [ 53 ];
    "br-np".allowedTCPPorts = [ 53 ];
    "wg-server".allowedUDPPorts = [ 53 ];
    "wg-server".allowedTCPPorts = [ 53 ];
  };
  l.nftables = {
    extraForward = ''
      ct state invalid drop
      ct state established,related accept

      iifname br-nhp oifname eth0 ct state new accept
      iifname eth0 oifname br-nhp ct state new accept
      iifname br-nh oifname eth0 ct state new accept
      iifname br-n oifname eth0 ct state new accept
      iifname eth0 oifname br-np ct state new accept
      iifname br-np oifname eth0 ct state new accept

      iifname wg-server oifname br-nhp ct state new accept
      iifname br-nhp oifname wg-server ct state new accept
      iifname wg-server oifname br-nh ct state new accept
      iifname br-nh oifname wg-server ct state new accept

      iifname br-nhp oifname br-nh ct state new accept
      iifname br-nh oifname br-nhp ct state new accept
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
