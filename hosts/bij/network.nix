{ ... }:

{
  networking.hostName = "bij";
  networking.domain = "net.leona.is";
  systemd.network = {
    links."10-eth0" = {
      matchConfig.MACAddress = "96:00:01:cf:2e:1c";
      linkConfig.Name = "eth0";
    };
    networks."10-eth0" = {
      DHCP = "yes";
      matchConfig = {
        Name = "eth0";
      };
      address = [
        "2a01:4f8:c010:1098::1/64"
      ];
      routes = [
        { routeConfig = { Destination = "::/0"; Gateway = "fe80::1"; GatewayOnLink = true; }; }
      ];
    };
    links."10-eth-nat" = {
      matchConfig.MACAddress = "86:00:00:32:55:86";
      linkConfig.Name = "eth-nat";
    };
    networks."10-eth-nat" = {
      matchConfig.Name = "eth-nat";
      address = [ "10.62.41.2/32" ];
      routes = [
        { routeConfig = { Destination = "10.62.41.0/24"; Gateway = "10.62.41.1"; GatewayOnLink = true; }; }
      ];
    };
  };
  l.nftables = {
    extraForward = ''
      ct state invalid drop
      ct state established,related accept

      iifname eth-nat oifname eth0 ct state new accept
    '';
    extraConfig = ''
      table ip nat {
        chain prerouting {
          type nat hook prerouting priority 0; policy accept;
        }

        chain postrouting {
          type nat hook postrouting priority 100; policy accept;
          iifname eth-nat oifname eth0 masquerade
        }
      }
    '';
  };

  boot.kernel.sysctl."net.ipv6.conf.all.forwarding" = true;
  boot.kernel.sysctl."net.ipv4.conf.all.forwarding" = true;
  networking.useHostResolvConf = false;
}
