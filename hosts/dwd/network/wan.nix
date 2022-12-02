{ config, lib, ... }:
{
  l.sops.secrets."hosts/dwd/pppd_secrets".owner = "root";
  environment.etc."ppp/pap-secrets".source = config.sops.secrets."hosts/dwd/pppd_secrets".path;

  services.pppd = {
    enable = true;
    peers = {
      dtag = {
        # Autostart the PPPoE session on boot
        autostart = true;
        enable = true;
        config = ''
          plugin rp-pppoe.so

          # interface name
          eth0.7

          name 0023112242025510117100420001@t-online.de

          persist
          maxfail 0
          holdoff 5

          noipdefault
          hide-password
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
    links."10-eth0" = {
      matchConfig.MACAddress = "00:0d:b9:5a:b3:f0";
      linkConfig.Name = "eth0";
    };
    networks."10-eth0" = {
      matchConfig.Name = "eth0";
#      address = [ "fd8f:d15b:9f40:1::1/64" ];
      DHCP = "yes";
      vlan = [
        "eth0.7"
      ];
    };
    netdevs."10-eth0.7" = {
      netdevConfig = {
        Name = "eth0.7";
        Kind = "vlan";
      };
      vlanConfig.Id = 7;
    };
    networks."10-eth0.7" = {
      matchConfig.name = "eth0.7";
      linkConfig.ActivationPolicy = "always-up";
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
      address = [ "fd8f:d15b:9f40:100::1/64" ];
      DHCP = "ipv6";
      dhcpV6Config = {
        WithoutRA = "solicit";
      };
#      dhcpPrefixDelegationConfig = {
#  #        UplinkInterface = ":self";
#        SubnetId = 0;
#        Announce = false;
#      };
      routes = [
#        { routeConfig = {
#          Destination = "195.39.247.188/32";
#          Scope = "link";
#          GatewayOnLink = true;
#        }; }
        { routeConfig = {
          Destination = "2a0f:4ac0:0:1::d25/128";
          Gateway = "_ipv6ra";
        }; }
      ];
    };
  };
}
