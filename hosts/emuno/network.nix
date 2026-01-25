{ config, lib, ... }:
{
  networking.hostName = "emuno";
  networking.domain = "net.infinitespace.dev";
  systemd.network = {
    links = {
      "10-eth0" = {
        matchConfig.MACAddress = "52:54:00:f2:da:4a";
        linkConfig.Name = "eth0";
      };
    };
    networks = {
      "10-eth0" = {
        DHCP = "yes";
        matchConfig = {
          Name = "eth0";
        };
        address = [
          "95.217.67.9/32"
          "2a01:4f9:3a:1448:4000:12::/128"
        ];
        dns = [
          "172.16.10.1"
          "2a01:4f9:3a:1448:4000::"
        ];
        routes = [
          {
            Destination = "::/0";
            Gateway = "2a01:4f9:3a:1448:4000::";
          }
          {
            Destination = "2a01:4f9:3a:1448:4000::/66";
          }
          {
            Destination = "0.0.0.0/0";
            Gateway = "172.16.10.1";
            GatewayOnLink = true;
          }
        ];
      };
    };
  };

  networking.useHostResolvConf = false;
}
