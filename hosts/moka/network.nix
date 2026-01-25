{ config, lib, ... }:
{
  networking.hostName = "moka";
  networking.domain = "net.infinitespace.dev";
  systemd.network = {
    links = {
      "10-eth0" = {
        matchConfig.MACAddress = "bc:fc:e7:6c:ab:0d";
        linkConfig.Name = "eth0";
      };
    };
    netdevs = {
      "15-br-vms" = {
        netdevConfig = {
          Name = "br-vms";
          Kind = "bridge";
        };
      };
    };
    networks = {
      "10-eth0" = {
        DHCP = "no";
        matchConfig = {
          Name = "eth0";
        };
        address = [
          "135.181.140.95/26"
          "2a01:4f9:3a:1448::/68"
        ];
        dns = [ "2001:4860:4860::8888" ];
        routes = [
          {
            Destination = "0.0.0.0/0";
            Gateway = "135.181.140.65";
            GatewayOnLink = true;
          }
          {
            Destination = "::/0";
            Gateway = "fe80::1";
            GatewayOnLink = true;
          }
        ];
      };
      "15-br-vms" = {
        matchConfig = {
          Name = "br-vms";
        };
        address = [
          "172.16.10.1/24"
          "2a01:4f9:3a:1448:4000::/66"
        ];
        routes =
          builtins.map
            (addr: {
              routeConfig = {
                Destination = addr;
                Scope = "link";
              };
            })
            [
              "95.217.67.8"
              "95.217.67.9"
              "95.217.67.10"
            ];
        linkConfig = {
          RequiredForOnline = false;
        };
        networkConfig.ConfigureWithoutCarrier = true;
      };
    };
  };

  # Accept all forwardings for public IPs
  # NAT IPs are handled withing networking.nat
  networking.firewall = {
    extraForwardRules = ''
      ip saddr 95.217.67.8/29 oifname eth0 accept
      iifname eth0 ip daddr 95.217.67.8/29 accept
      ip6 saddr 2a01:4f9:3a:1448:4000::/66 accept
      ip6 daddr 2a01:4f9:3a:1448:4000::/66 accept
      ip6 saddr 2a01:4f9:3a:1448:c0ff:ee:f00d:0/112 accept
      ip6 daddr 2a01:4f9:3a:1448:c0ff:ee:f00d:0/112 accept
    '';
  };

  networking.nat = {
    enable = true;
    externalIP = "135.181.140.95";
    internalIPs = [
      "172.16.10.0/24"
    ];
  };

  boot.kernel.sysctl."net.ipv6.conf.all.forwarding" = true;
  boot.kernel.sysctl."net.ipv4.conf.all.forwarding" = true;
  networking.useHostResolvConf = false;
}
