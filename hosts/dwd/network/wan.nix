{ config, lib, ... }:
{
  systemd.network = {
    # PHYSICAL
    links."10-eth0" = {
      matchConfig.MACAddress = "00:0d:b9:5a:b3:f0";
      linkConfig.Name = "eth0";
    };
    networks."10-eth0" = {
      matchConfig.Name = "eth0";
#      address = [ "fd8f:d15b:9f40:1::1/64" ];
      DHCP = "yes";
    };
  };
}
