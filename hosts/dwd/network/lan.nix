{ ... }:
{
  systemd.network = {
    # BRIDGES
    netdevs."05-br-lan" = {
      netdevConfig = {
        Name = "br-lan";
        Kind = "bridge";
      };
    };
    networks."05-br-lan" = {
      matchConfig = {
        Name = "br-lan";
      };
      address = [
        "10.151.0.1/22"
        "fd8f:d15b:9f40:10::1/64"
      ];
      networkConfig = {
        ConfigureWithoutCarrier = true;
        DHCPv6PrefixDelegation = true;
      };
      dhcpV6Config = {
        PrefixDelegationHint = 1;
      };
    };

    netdevs."05-br-tethys" = {
      netdevConfig = {
        Name = "br-tethys";
        Kind = "bridge";
      };
    };
    networks."05-br-tethys" = {
      matchConfig = {
        Name = "br-tethys";
      };
      address = [
        "10.151.4.254/24"
        "fd8f:d15b:9f40:11::1/64"
      ];
      networkConfig = {
        ConfigureWithoutCarrier = true;
        DHCPv6PrefixDelegation = true;
      };
      dhcpV6Config = {
        PrefixDelegationHint = 2;
      };
      routes = [
        { routeConfig.Destination = "195.39.247.144/32"; }
        { routeConfig.Destination = "195.39.247.145/32"; }
        {
          routeConfig = {
            Destination = "2a0f:4ac0:1e0:100::/64";
            Gateway = "fd8f:d15b:9f40:11:2c5a:56ff:fe4f:e4c4";
          };
        }
        {
          routeConfig = {
            Destination = "2a0f:4ac0:1e0:101::/64";
            Gateway = "fd8f:d15b:9f40:11:8079:3aff:fe35:9ddc";
          };
        }
      ];
    };

    netdevs."05-br-dmz" = {
      netdevConfig = {
        Name = "br-dmz";
        Kind = "bridge";
      };
    };
    networks."05-br-dmz" = {
      matchConfig = {
        Name = "br-dmz";
      };
      address = [
        "10.151.6.1/24"
      ];
      networkConfig = {
        ConfigureWithoutCarrier = true;
        DHCPv6PrefixDelegation = true;
      };
    };

    # PHYSICAL
    links."10-eth1" = {
      matchConfig.MACAddress = "00:0d:b9:5a:b3:f1";
      linkConfig.Name = "eth1";
    };
    networks."10-eth1" = {
      matchConfig = {
        Name = "eth1";
      };
      networkConfig = {
        Bridge = "br-lan";
      };
    };
    links."10-eth2" = {
      matchConfig = {
        MACAddress = "00:0d:b9:5a:b3:f2";
        Type = "ether"; # Important for VLAN configuration
      };
      linkConfig.Name = "eth2";
    };
    networks."10-eth2" = {
      matchConfig = {
        Name = "eth2";
      };
      networkConfig = {
        Bridge = "br-tethys";
        VLAN = "eth2.7";
      };
    };

    # PHYSICAL + VLAN
    netdevs."15-eth2.7" = {
      netdevConfig = {
        Name = "eth2.7";
        Kind = "vlan";
      };
      vlanConfig = {
        Id = 7;
      };
    };
    networks."15-eth2.7" = {
      matchConfig = {
        Name = "eth2.7";
      };
      networkConfig = {
        Bridge = "br-dmz";
      };
    };
  };
}
