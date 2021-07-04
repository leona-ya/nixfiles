{ config, lib, ... }:
{
  em0lar.secrets."pppd_secrets".owner = "root";

  environment.etc."ppp/pap-secrets".source = config.em0lar.secrets."pppd_secrets".path;
  environment.etc."ppp/chap-secrets".source = config.em0lar.secrets."pppd_secrets".path;

  services.pppd = {
    enable = true;
    peers = {
      versatel = {
        # Autostart the PPPoE session on boot
        autostart = true;
        enable = true;
        config = ''
          plugin rp-pppoe.so

          # interface name
          eth0

          name 1und1/pt4310-736@online.de

          persist
          maxfail 0
          holdoff 5

          noipdefault
          defaultroute
          hide-password
          noauth
          lcp-echo-interval 20
          lcp-echo-failure 3
          mtu 1492
          ifname ppp-wan
          +ipv6
        '';
      };
    };
  };
  systemd.network = {
    # PHYSICAL
    links."10-eth0" = {
      matchConfig.MACAddress = "00:0d:b9:5a:b3:f0";
      linkConfig.Name = "eth0";
    };
    networks."10-eth0" = {
      matchConfig.Name = "eth0";
      address = [ "fd8f:d15b:9f40:1::1/64" ];
    };

    # PPP
    networks."10-ppp-wan" = {
      matchConfig = {
        Name = "ppp-wan";
      };
      networkConfig = {
        IPv6AcceptRA = true;
        KeepConfiguration = true;
      };
      address = [ "fd8f:d15b:9f40::1/64" ];
      DHCP = "ipv6";
      dhcpV6Config = {
        ForceDHCPv6PDOtherInformation = true;
      };
    };
  };

  services.cron = {
    enable = true;
    systemCronJobs = [
      "30 3 * * * root systemctl restart pppd-versatel" # Versatel reconnects DSL after 24 hours
    ];
  };
}
