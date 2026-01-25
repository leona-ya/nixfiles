{ config, lib, ... }:
{
  networking.hostName = "laurake";
  networking.domain = "net.infinitespace.dev";
  systemd.network = {
    links = {
      "10-eth0" = {
        matchConfig.MACAddress = "52:54:00:f3:8e:a7";
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
          "172.16.10.3/32"
          "2a01:4f9:3a:1448:4000:10::/128"
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
