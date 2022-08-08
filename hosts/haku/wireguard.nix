{ lib, config, ... }:
let
  hosthelper = import ../../hosts { inherit lib config; };
in {
  networking.firewall.allowedUDPPorts = [
    51440
    51441
    51442
  ];
  l.sops.secrets = {
    "hosts/haku/wireguard_wg-public_privatekey".owner = "systemd-network";
    "hosts/haku/wireguard_wg-server_privatekey".owner = "systemd-network";
    "hosts/haku/wireguard_wg-clients_privatekey".owner = "systemd-network";
  };
  l.nftables.extraForward = ''
    ct state invalid drop
    ct state established,related accept
    iifname wg-public ct state new accept
    oifname wg-public ct state new accept
    iifname wg-clients oifname wg-server ct state new accept
    iifname wg-clients oifname wg-clients ct state new accept
    iifname wg-server oifname wg-clients ct state new accept
    iifname wg-server oifname wg-server ct state new accept
  '';
  systemd.network = {
    netdevs = hosthelper.groups.wireguard.g_systemd_network_netdevconfig // {
      "30-wg-clients" = {
        netdevConfig = {
          Kind = "wireguard";
          Name = "wg-clients";
        };
        wireguardConfig = {
          ListenPort = 51442;
          PrivateKeyFile = config.sops.secrets."hosts/haku/wireguard_wg-clients_privatekey".path;
        };
        wireguardPeers = [
          { # turingmachine
            wireguardPeerConfig = {
              AllowedIPs = [
                "10.151.9.2/32"
                "fd8f:d15b:9f40:0901::1/72"
              ];
              PublicKey = "gOBDoXc3zWVpnyx81fgVKmR2un14MW+c+SM/G6F3sFY=";
            };
          }
          { # nyx
            wireguardPeerConfig = {
              AllowedIPs = [
                "10.151.9.3/32"
                "fd8f:d15b:9f40:0901:200::1/72"
              ];
              PublicKey = "MdSVqYNSF2Lylb1kTdfW33ZwQcGff1ueQRrjiPeqDVg=";
            };
          }
          { # leko
            wireguardPeerConfig = {
              AllowedIPs = [
                "10.151.9.4/32"
                "fd8f:d15b:9f40:0901:100::1/72"
              ];
              PublicKey = "uDe4SqBm4ohNX9AZJOW4Uk7j1xIIgBAkll4NC1vdpDo=";
            };
          }
          { # Luna [DM]
            wireguardPeerConfig = {
              AllowedIPs = [
                "10.151.9.5/32"
                "fd8f:d15b:9f40:0902::1/72"
              ];
              PublicKey = "0tlj84AXn/vVl7fAkgKsDcAcW3CN4y92sr/MKL9TBRI=";
            };
          }
          { # Luna Phone [DM]
            wireguardPeerConfig = {
              AllowedIPs = [
                "10.151.9.6/32"
                "fd8f:d15b:9f40:0902:100::1/72"
              ];
              PublicKey = "C8MU9Zqx740SjEYPjzIgCOlbe/D6HkDU+Vh6XwVMhFg=";
            };
          }
        ];
      };
    };

    networks = hosthelper.groups.wireguard.g_systemd_network_networkconfig // {
      "30-wg-clients" = {
        name = "wg-clients";
        linkConfig = { RequiredForOnline = "no"; };
        address = [
          "10.151.9.1/32"
          "fd8f:d15b:9f40:0900::1/64"
        ];
        networkConfig = {
          IPForward = true;
        };
        routes = [
          { routeConfig.Destination = "10.151.9.0/24"; }
          { routeConfig.Destination = "fd8f:d15b:9f40:0900::/56"; }
        ];
      };
    };
  };
}
