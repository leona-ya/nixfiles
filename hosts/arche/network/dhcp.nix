{ ... }: {
  services.kea.dhcp4 = {
    enable = true;
    settings = {
      interfaces-config = {
        interfaces = [ "br-clients" ];
      };
      subnet4 = [
        {
          id = 1;
          subnet = "10.20.0.0/23";
          pools = [ { pool = "10.20.0.10 - 10.20.1.254"; } ];
          option-data = [
            {
              name = "routers";
              data = "10.20.0.1";
            }
            {
              name = "domain-name-servers";
              data = "10.20.0.1";
            }
          ];
          reservations = [
            {
              hostname = "hass";
              hw-address = "b8:27:eb:4c:17:f8";
              ip-address = "10.20.0.5";
            }
          ];
        }
      ];
    };
  };
  services.radvd = {
    enable = true;
    config = ''
      interface br-clients {
        AdvSendAdvert on;
        MinRtrAdvInterval 3;
        MaxRtrAdvInterval 10;
        prefix ::/64 {
          AdvOnLink on;
          AdvAutonomous on;
          AdvRouterAddr on;
        };
        RDNSS fd14:65c0:ffee:0::1 { };
      };
    '';
  };
}
