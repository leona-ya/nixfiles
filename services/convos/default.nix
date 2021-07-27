{ config, ... }:

{
  services.convos = {
    enable = true;
    reverseProxy = true;
  };
  systemd.services.convos.environment = {
    CONVOS_REQUEST_BASE = "https://convos.em0lar.dev";
  };

  services.nginx.virtualHosts."convos.em0lar.dev" = {
    forceSSL = true;
    enableACME = true;
    locations = {
      "/" = {
        proxyPass = "http://localhost:${toString config.services.convos.listenPort}";
        proxyWebsockets = true;
      };
    };
  };
}
