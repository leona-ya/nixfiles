{ ... }: {
  systemd.network = {
    # BRIDGES
    netdevs."10-br-clients" = {
      netdevConfig = {
        Name = "br-clients";
        Kind = "bridge";
      };
    };
    networks."20-br-clients" = {
      matchConfig.Name = "br-clients";
      address = [
        "10.20.0.1/23"
        "fd14:65c0:ffee:0::1/64"
      ];
      networkConfig = {
        ConfigureWithoutCarrier = true;
        DHCPPrefixDelegation = true;
        IPv6AcceptRA = false;
      };
      dhcpV6Config.PrefixDelegationHint = "::/64";
      dhcpV6PrefixDelegationConfig = {
        SubnetID = "0";
        Announce = true;
      };
    };
    # PHYSICAL
    networks."10-eth-rcy" = {
      matchConfig = {
        Name = "eth-rcy";
      };
      networkConfig = {
        Bridge = "br-clients";
      };
    };
  };
}
