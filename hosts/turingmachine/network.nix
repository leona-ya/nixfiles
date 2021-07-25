{ config, ... }:

{
  networking.useDHCP = false;
  networking.hostName = "turingmachine";
  networking.domain = "net.em0lar.dev";
  services.resolved.domains = [
    "lan"
  ];

  networking.wireless = {
    enable = true;
    interfaces = [ "wifi0" ];
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
      matchConfig.MACAddress = "d4:6d:6d:cb:11:f0";
      linkConfig.Name = "wifi0";
    };
    networks."10-wifi0" = {
      DHCP = "yes";
      matchConfig = {
        Name = "wifi0";
      };
    };
  };
  em0lar.secrets = {
    "wpa_supplicant.conf".owner = "root";
  };
  environment.etc."wpa_supplicant.conf".source = config.em0lar.secrets."wpa_supplicant.conf".path;
}
