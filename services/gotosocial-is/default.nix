{ ... }:
{
  services.gotosocial = {
    enable = true;
    setupPostgresqlDB = true;
    settings = {
      application-name = "Infinite Space social";
      host = "social.infinitespace.dev";
      protocol = "https";
      bind-address = "127.0.0.1";
      port = 41122;
      log-level = "debug";
      advanced-rate-limit-requests = 0;
    };
  };
  services.nginx = {
    clientMaxBodySize = "40M";
    virtualHosts = {
      "social.infinitespace.dev" = {
        enableACME = true;
        forceSSL = true;
        kTLS = true;
        locations = {
          "/" = {
            recommendedProxySettings = true;
            proxyWebsockets = true;
            proxyPass = "http://127.0.0.1:41122";
            extraConfig = ''
              access_log /var/log/nginx/access-gts.log;
            '';
          };
        };
      };
    };
  };
}
