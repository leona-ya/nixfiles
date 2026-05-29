{ config, ... }:
{
  services.thelounge = {
    enable = true;
    extraConfig = {
      reverseProxy = true;
    };
  };

  services.nginx.virtualHosts."webirc.infinitespace.dev" = {
    enableACME = true;
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://localhost:${toString config.services.thelounge.port}";
      proxyWebsockets = true;
      extraConfig = ''
        proxy_read_timeout 1d;
      '';
    };
  };
}
