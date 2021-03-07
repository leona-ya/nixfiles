{ config, ... }:

{
  networking.firewall.allowedUDPPorts = [
    51440
  ];
  boot.extraModulePackages = [ config.boot.kernelPackages.wireguard ];
  em0lar.secrets."wireguard_wg0_privatekey" = {
    source-path = "${../../secrets/haku/wireguard_wg0_privatekey.gpg}";
    owner = "systemd-network";
    group-name = "systemd-network";
  };
  em0lar.nftables.extraForward = ''
    ct state invalid drop
    ct state established,related accept
    iifname wg0 ct state new accept
    oifname wg0 ct state new accept
  '';
  systemd.network.netdevs."30-wg0" = {
    netdevConfig = {
      Kind = "wireguard";
      Name = "wg0";
    };
    wireguardConfig = {
      FirewallMark = 51440;
      ListenPort = 51440;
      PrivateKeyFile = config.em0lar.secrets."wireguard_wg0_privatekey".path;
    };
    wireguardPeers = [
      { # foros
        wireguardPeerConfig = {
          AllowedIPs = [
            "195.39.247.144/32"
            "2a0f:4ac0:1e0:100::/64"
          ];
          PublicKey = "CnswutrDvUJdDIsopjkvjO/SiOrKdx3ob0jvDf0LLFI=";
        };
      }
      { # beryl
        wireguardPeerConfig = {
          AllowedIPs = [
            "195.39.247.145/32"
            "2a0f:4ac0:1e0:101::/64"
          ];
          PublicKey = "DBfzjdPqk5Ee8OYsqNy2LoM7kvbh8ppmK836jlGz43s=";
        };
      }
    ];
  };
  systemd.network.networks."30-wg0" = {
    name = "wg0";
    linkConfig = { RequiredForOnline = "no"; };
    address = [
      "2a0f:4ac0:1e0::1/48"
    ];
    networkConfig = {
      IPForward = true;
    };
    routes = [
      { routeConfig.Destination = "195.39.247.144/28"; }
      { routeConfig.Destination = "2a0f:4ac0:1e0::/48"; }
    ];
  };
}
