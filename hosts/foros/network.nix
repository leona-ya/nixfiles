{ ... }:

{
  networking.hostName = "foros";
  networking.domain = "net.leona.is";
  systemd.network = {
    links."10-eth-internal" = {
      matchConfig.MACAddress = "52:54:00:3a:68:5c";
      linkConfig.Name = "eth-internal";
    };
    networks."10-eth-internal" = {
      DHCP = "yes";
      matchConfig = {
        Name = "eth-internal";
      };
    };

    links."10-eth-internet" = {
      matchConfig.MACAddress = "52:54:00:b9:bf:c9";
      linkConfig.Name = "eth-internet";
    };
    networks."10-eth-internet" = {
      DHCP = "yes";
      matchConfig = {
        Name = "eth-internet";
      };
    };
  };


  networking.useHostResolvConf = false;
  l.nftables.checkIPTables = false;
}
