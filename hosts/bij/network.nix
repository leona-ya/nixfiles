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
  };

  networking.useHostResolvConf = false;
}
