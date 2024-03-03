{ config, pkgs, ... }:

{
  services.kresd = {
    package = pkgs.knot-resolver.override { extraFeatures = true; };
    extraConfig = ''
      modules.load('http')
      net.listen('127.0.0.1', 8453, { kind = 'webmgmt' })
      policy.add(policy.suffix(policy.FLAGS({'NO_CACHE', 'NO_EDNS', 'NO_0X20'}), {todname('lan.')}))
      policy.add(policy.suffix(policy.STUB('10.151.0.1'), {todname('lan.')}))
    '';
  };
  networking.useDHCP = false;
  networking.hostName = "freyda";
  networking.domain = "net.leona.is";
  services.resolved.domains = [
    "lan"
  ];

  networking.wireless.iwd.enable = true;
  systemd.network = {
    networks."99-default" = {
      DHCP = "yes";
      matchConfig.Name = "*";
    };
    links."10-eth0" = {
      matchConfig.MACAddress = "9c:bf:0d:00:35:53";
      linkConfig.Name = "eth0";
    };
    networks."10-eth0" = {
      DHCP = "yes";
      matchConfig.Name = "eth0";
      linkConfig = { RequiredForOnline = "yes"; };
      dhcpV4Config = {
        RouteMetric = 512;
      };
      dhcpV6Config = {
        RouteMetric = 512;
      };
      routes = [
        {
          routeConfig = {
            Destination = "168.119.100.247/32";
            Gateway = "_dhcp4";
          };
        }
        {
          routeConfig = {
            Destination = "2a01:4f8:c010:1098::1/128";
            Gateway = "_ipv6ra";
          };
        }
      ];
    };
    links."10-wifi0" = {
      matchConfig.MACAddress = "14:ac:60:46:9e:43";
      linkConfig.Name = "wifi0";
    };
    networks."10-wifi0" = {
      DHCP = "yes";
      matchConfig.MACAddress = "14:ac:60:46:9e:43";
      linkConfig = { RequiredForOnline = "yes"; };
      routes = [
        {
          routeConfig = {
            Destination = "168.119.100.247/32";
            Gateway = "_dhcp4";
          };
        }
        {
          routeConfig = {
            Destination = "2a01:4f8:c010:1098::1/128";
            Gateway = "_ipv6ra";
          };
        }
      ];
    };
  };
}
