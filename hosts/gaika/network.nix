{ ... }:

{
  networking.hostName = "gaika";
  networking.domain = "net.leona.is";
  systemd.network = {
    links."10-eth0" = {
      matchConfig.MACAddress = "02:11:32:2a:88:8e";
      linkConfig.Name = "eth0";
    };
    networks."10-eth0" = {
      DHCP = "yes";
      matchConfig = {
        Name = "eth0";
      };
      networkConfig.IPv6PrivacyExtensions = "no";
    };
  };
  networking.useHostResolvConf = false;
  boot.kernel.sysctl."net.ipv6.conf.all.forwarding" = true;
  boot.kernel.sysctl."net.ipv4.conf.all.forwarding" = true;
}
