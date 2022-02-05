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
  networking.domain = "net.em0lar.dev";
  services.resolved.domains = [
    "lan"
  ];

  networking.wireless.iwd = {
    enable = true;
  };
  systemd.network = {
    links."10-eth0" = {
      matchConfig.MACAddress = "8c:16:45:89:d1:64";
      linkConfig.Name = "eth0";
    };
    networks."10-eth0" = {
      DHCP = "yes";
      matchConfig = {
        Name = "eth0";
      };
      dhcpV4Config = {
        RouteMetric = 512;
      };
      dhcpV6Config = {
        RouteMetric = 512;
      };
    };
    links."10-wifi0" = {
      matchConfig.MACAddress = "38:de:ad:67:b3:7b";
      linkConfig.Name = "wifi0";
    };
    networks."10-wifi0" = {
      DHCP = "yes";
      matchConfig.MACAddress = "38:de:ad:67:b3:7b";
    };
  };
  em0lar.sops.secrets = {
    "hosts/turingmachine/wpa_supplicant.conf" = {};
  };
  environment.etc."wpa_supplicant.conf".source = config.sops.secrets."hosts/turingmachine/wpa_supplicant.conf".path;
}
