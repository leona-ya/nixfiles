{ ... }:

{
  services.dhcpd4 = {
    enable = true;
    interfaces = [
      "br-lan"
      "br-tethys"
      "br-dmz"
    ];
    extraConfig = ''
      min-lease-time 21600;
      default-lease-time 345600;
      max-lease-time 604800;
      option domain-name "lan";
      option domain-name-servers 10.151.0.1;
      ddns-domainname "lan";

      ddns-update-style interim;
      ignore client-updates;

      zone lan. {
        primary 127.0.0.1;
      }

      subnet 10.151.0.0 netmask 255.255.252.0 {
        range 10.151.2.1 10.151.2.254;
        option routers 10.151.0.1;
      }
      subnet 10.151.4.0 netmask 255.255.255.0 {
        range 10.151.4.3 10.151.4.253;
        option routers 10.151.4.254;
      }
      subnet 10.151.6.0 netmask 255.255.255.0 {
        range 10.151.6.2 10.151.6.253;
        option routers 10.151.6.1;
      }

      # STATIC IPs
      host coreswitch {
        option host-name "coreswitch.lan";
        hardware ethernet a4:2b:8c:12:5b:96;
        fixed-address 10.151.0.4;
       }
      host ap-unifi-1 {
        option host-name "ap-unifi-1.lan";
        hardware ethernet 80:2a:a8:93:df:57;
        fixed-address 10.151.0.129;
       }
      host ap-unifi-2 {
        option host-name "ap-unifi-2.lan";
        hardware ethernet fc:ec:da:3a:24:67;
        fixed-address 10.151.0.130;
      }
      host hue {
        option host-name "hue.lan";
        hardware ethernet 00:17:88:21:71:71;
        fixed-address 10.151.1.2;
      }
      host printer {
        option host-name "printer.lan";
        hardware ethernet 30:cd:a7:b4:dc:3f;
        fixed-address 10.151.1.3;
      }
      host sonos-kitchen-l {
        option host-name "sonos-kitchen-l.lan";
        hardware ethernet 00:0e:58:54:e3:54;
        fixed-address 10.151.1.64;
      }
      host sonos-kitchen-r {
        option host-name "sonos-kitchen-r.lan";
        hardware ethernet 00:0e:58:54:e3:60;
        fixed-address 10.151.1.65;
      }
      host sonos-bathroom {
        option host-name "sonos-bathroom.lan";
        hardware ethernet 00:0e:58:5e:b5:9a;
        fixed-address 10.151.1.66;
      }
      host sonos-em0lar {
        option host-name "sonos-leona.lan";
        hardware ethernet 00:0e:58:cd:70:3c;
        fixed-address 10.151.1.67;
      }
      host sonos-em0lar-attic {
        option host-name "sonos-em0lar-attic.lan";
        hardware ethernet 94:9f:3e:19:c1:62;
        fixed-address 10.151.1.68;
      }
      host sonos-livingroom {
        option host-name "sonos-livingroom.lan";
        hardware ethernet 94:9f:3e:6a:85:e5;
        fixed-address 10.151.1.69;
      }
      host sonos-livingroom-sl {
        option host-name "sonos-livingroom-sl.lan";
        hardware ethernet 78:28:ca:e9:7d:0e;
        fixed-address 10.151.1.70;
      }
      host sonos-livingroom-sr {
        option host-name "sonos-livingroom-sr.lan";
        hardware ethernet 78:28:ca:e9:37:ca;
        fixed-address 10.151.1.71;
      }
      host tethys {
        option host-name "tethys.lan";
        hardware ethernet 3c:d9:cc:ad:6e:31;
        fixed-address 10.151.4.1;
      }
      host phoebe {
        option host-name "phoebe.lan";
        hardware ethernet aa:53:96:a0:ee:47;
        fixed-address 10.151.4.11;
      }
      host paul-ext {
        option host-name "paul-ext.lan";
        hardware ethernet c6:a0:97:d3:86:00;
        fixed-address 10.151.4.14;
      }
      host encladus {
        option host-name "encladus.lan";
        hardware ethernet 00:11:32:69:05:05;
        fixed-address 10.151.1.1;
      }
      host utopia {
        option host-name "utopia.lan";
        hardware ethernet ae:45:c5:d6:11:b3;
        fixed-address 10.151.4.26;
      }
    '';
  };
  services.radvd = {
    enable = true;
    config = ''
      interface br-lan {
        AdvSendAdvert on;
        MinRtrAdvInterval 3;
        MaxRtrAdvInterval 10;
        prefix ::/64 {
          AdvOnLink on;
          AdvAutonomous on;
          AdvRouterAddr on;
        };
        RDNSS fd8f:d15b:9f40:10::1 { };
      };
      interface br-tethys {
        AdvSendAdvert on;
        MinRtrAdvInterval 3;
        MaxRtrAdvInterval 10;
        prefix ::/64 {
          AdvOnLink on;
          AdvAutonomous on;
          AdvRouterAddr on;
        };
        RDNSS fd8f:d15b:9f40:20::1 { };
      };
      interface br-dmz {
        AdvSendAdvert on;
        MinRtrAdvInterval 3;
        MaxRtrAdvInterval 10;
        prefix ::/64 {
          AdvOnLink on;
          AdvAutonomous on;
          AdvRouterAddr on;
        };
        RDNSS fd8f:d15b:9f40::1 { };
      };
    '';
  };
}
