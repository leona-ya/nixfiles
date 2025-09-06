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
  networking.hostName = "turingmachine";
  networking.domain = "net.leona.is";
  services.resolved.domains = [
    "lan"
  ];

  networking.wireless.iwd.enable = true;
  systemd.network = {
    links."10-eth0" = {
      matchConfig.MACAddress = "8c:16:45:89:d1:64";
      linkConfig.Name = "eth0";
    };
    networks."10-eth0" = {
      DHCP = "yes";
      matchConfig.Name = "eth0";
      linkConfig = {
        RequiredForOnline = "yes";
      };
      dhcpV4Config = {
        RouteMetric = 512;
      };
      dhcpV6Config = {
        RouteMetric = 512;
      };
      routes = [
        {
          Destination = "168.119.100.247/32";
          Gateway = "_dhcp4";
        }
        {
          Destination = "2a01:4f8:c010:1098::1/128";
          Gateway = "_ipv6ra";
        }
      ];
    };
    links."10-wifi0" = {
      matchConfig.MACAddress = "38:de:ad:67:b3:7b";
      linkConfig.Name = "wifi0";
    };
    networks."10-wifi0" = {
      DHCP = "yes";
      matchConfig.MACAddress = "38:de:ad:67:b3:7b";
      linkConfig = {
        RequiredForOnline = "yes";
      };
      routes = [
        {
          Destination = "168.119.100.247/32";
          Gateway = "_dhcp4";
        }
        {
          Destination = "2a01:4f8:c010:1098::1/128";
          Gateway = "_ipv6ra";
        }
      ];
    };
  };
}
