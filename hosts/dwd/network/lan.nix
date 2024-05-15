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
        "10.151.4.1/22"
        "fd8f:d15b:9f40:101::1/64"
      ];
      networkConfig = {
        ConfigureWithoutCarrier = true;
        DHCPPrefixDelegation = true;
        IPv6AcceptRA = false;
      };
      #      dhcpV6Config = {
      #        PrefixDelegationHint = "::/64";
      #      };
      #      dhcpV6PrefixDelegationConfig = {
      ##        UplinkInterface = "ppp-wan";
      #        SubnetId = 0;
      ##        Announce = true;
      #      };
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
        Bridge = "br-lan";
      };
    };
    links."10-eth3" = {
      matchConfig = {
        MACAddress = "00:0d:b9:5a:b3:f3";
        Type = "ether";
      };
      linkConfig.Name = "eth3";
    };
    networks."10-eth3" = {
      matchConfig = {
        Name = "eth3";
      };
      networkConfig = {
        Bridge = "br-lan";
      };
    };
  };
}
