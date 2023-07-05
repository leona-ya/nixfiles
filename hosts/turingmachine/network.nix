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
            Destination = "195.39.247.188/32";
            Gateway = "_dhcp4";
          };
        }
        {
          routeConfig = {
            Destination = "2a0f:4ac0:0:1::d25/128";
            Gateway = "_ipv6ra";
          };
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
      linkConfig = { RequiredForOnline = "yes"; };
      routes = [
        {
          routeConfig = {
            Destination = "195.39.247.188/32";
            Gateway = "_dhcp4";
          };
        }
        {
          routeConfig = {
            Destination = "2a0f:4ac0:0:1::d25/128";
            Gateway = "_ipv6ra";
          };
        }
      ];
    };
    networks."10-enp0s20f0u4" = {
      DHCP = "yes";
      matchConfig.Name = "enp0s20f0u4";
      linkConfig = { RequiredForOnline = "no"; };
    };
  };
  l.sops.secrets = {
    "hosts/turingmachine/wpa_supplicant.conf" = {};
  };
  environment.etc."wpa_supplicant.conf".source = config.sops.secrets."hosts/turingmachine/wpa_supplicant.conf".path;
}
