{ ... }:

{
  networking.hostName = "beryl";
  networking.domain = "net.leona.is";
  systemd.network = {
    links = {
      "10-eth-internal" = {
        matchConfig.MACAddress = "52:54:00:4e:5c:bf";
        linkConfig.Name = "eth-internal";
      };
      "10-eth-internet" = {
        matchConfig.MACAddress = "52:54:00:ba:40:5c";
        linkConfig.Name = "eth-internet";
      };
    };
    networks = {
      "10-eth-internal" = {
        DHCP = "yes";
        matchConfig = {
          Name = "eth-internal";
        };
        networkConfig.IPv6PrivacyExtensions = "no";
      };
      "10-eth-internet" = {
        DHCP = "yes";
        matchConfig = {
          Name = "eth-internet";
        };
        networkConfig.IPv6PrivacyExtensions = "no";
      };
    };
  };
  networking.useHostResolvConf = false;
  l.nftables.checkIPTables = false;
}
