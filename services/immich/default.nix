{ config, ... }:
{
  services.immich = {
    enable = true;
    accelerationDevices = [ "/dev/dri/renderD128" ];
  };

  services.nginx.virtualHosts."photos.leona.is" = {
    enableACME = true;
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://localhost:${toString config.services.immich.port}";
      proxyWebsockets = true;
      extraConfig = ''
        client_max_body_size 2048M;
      '';
    };
  };
}
