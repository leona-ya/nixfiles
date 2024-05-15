{ ... }:

{
  services.kea.dhcp4 = {
    enable = true;
    settings = {
      interfaces-config = { interfaces = [ "br-lan" ]; };
      subnet4 = [
        {
          subnet = "10.151.4.0/22";
          pools = [{ pool = "10.151.5.0 - 10.151.5.254"; }];
          option-data = [
            {
              name = "routers";
              data = "10.151.4.1";
            }
            {
              name = "domain-name-servers";
              data = "10.151.4.1";
            }
          ];
          reservations = [
            {
              hostname = "hue";
              hw-address = "ec:b5:fa:19:62:7a";
              ip-address = "10.151.4.128";
            }
          ];
        }
      ];
    };
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
        RDNSS fd8f:d15b:9f40:101::1 { };
      };
    '';
  };
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
