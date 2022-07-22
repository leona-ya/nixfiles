{ ... }:

{
  services.dhcpd4 = {
    enable = true;
    interfaces = [
      "br-lan"
    ];
    extraConfig = ''
      min-lease-time 21600;
      default-lease-time 345600;
      max-lease-time 604800;
      option domain-name "lan";
      option domain-name-servers 10.151.4.1;
      ddns-domainname "lan";

      ddns-update-style interim;
      ignore client-updates;

      zone lan. {
        primary 127.0.0.1;
      }

      subnet 10.151.4.0 netmask 255.255.252.0 {
        range 10.151.5.1 10.151.5.254;
        option routers 10.151.4.1;
      }
    '';
  };
#  services.radvd = {
#    enable = true;
#    config = ''
#      interface br-lan {
#        AdvSendAdvert on;
#        MinRtrAdvInterval 3;
#        MaxRtrAdvInterval 10;
#        prefix ::/64 {
#          AdvOnLink on;
#          AdvAutonomous on;
#          AdvRouterAddr on;
#        };
#        RDNSS fd8f:d15b:9f40:10::1 { };
#      };
#      interface br-tethys {
#        AdvSendAdvert on;
#        MinRtrAdvInterval 3;
#        MaxRtrAdvInterval 10;
#        prefix ::/64 {
#          AdvOnLink on;
#          AdvAutonomous on;
#          AdvRouterAddr on;
#        };
#        RDNSS fd8f:d15b:9f40:20::1 { };
#      };
#      interface br-dmz {
#        AdvSendAdvert on;
#        MinRtrAdvInterval 3;
#        MaxRtrAdvInterval 10;
#        prefix ::/64 {
#          AdvOnLink on;
#          AdvAutonomous on;
#          AdvRouterAddr on;
#        };
#        RDNSS fd8f:d15b:9f40::1 { };
#      };
#    '';
#  };
}
