{ config, ... }:
{
  services.audiobookshelf = {
    enable = true;
    port = 45221;
  };

  services.nginx.virtualHosts."abs.infinitespace.dev" = {
    enableACME = true;
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:${toString config.services.audiobookshelf.port}";
      proxyWebsockets = true;
      extraConfig = ''
        proxy_redirect http:// $scheme://;
      '';
    };
  };
}
