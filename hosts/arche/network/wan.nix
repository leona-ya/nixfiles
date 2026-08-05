{ config, ... }: {
  l.sops.secrets."hosts/arche/pppd_secrets".owner = "root";
  environment.etc."ppp/pap-secrets".source = config.sops.secrets."hosts/arche/pppd_secrets".path;

  services.pppd = {
    enable = true;
    peers = {
      congstar = {
        # Autostart the PPPoE session on boot
        autostart = true;
        enable = true;
        config = ''
          plugin pppoe.so

          # interface name
          eth-rcy.7

          name congstar

          persist
          maxfail 0
          holdoff 5

          noipdefault
          hide-password
          defaultroute
          noauth
          lcp-echo-interval 20
          lcp-echo-failure 3
          mtu 1492
          ifname ppp-wan
          +ipv6
        '';
      };
    };
  };
  systemd.network = {
    # PHYSICAL
    links."10-eth-rcy" = {
      matchConfig.MACAddress = "00:2b:67:19:c4:f0";
      linkConfig.Name = "eth-rcy";
    };
    networks."10-eth-rcy" = {
      matchConfig.Name = "eth-rcy";
      vlan = [
        "eth-rcy.7"
      ];
      linkConfig.ActivationPolicy = "up";
    };
    netdevs."10-eth-rcy.7" = {
      netdevConfig = {
        Name = "eth-rcy.7";
        Kind = "vlan";
      };
      vlanConfig.Id = 7;
    };
    networks."10-eth-rcy.7" = {
      matchConfig.name = "eth-rcy.7";
      linkConfig.ActivationPolicy = "up";
    };
    #PPP
    networks."10-ppp-wan" = {
      matchConfig = {
        Name = "ppp-wan";
      };
      networkConfig = {
        IPv6AcceptRA = true;
        KeepConfiguration = true;
      };
      DHCP = "ipv6";
      dhcpV6Config = {
        WithoutRA = "solicit";
      };
    };
  };
}
