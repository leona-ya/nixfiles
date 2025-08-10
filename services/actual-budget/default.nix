{ config, ... }: {
  l.sops.secrets."services/actual-budget/env" = {};
  services.actual = {
    enable = true;
    settings = {
      hostname = "::1";
      port = 62441;
      openId = {
        discoveryURL = "https://auth.leona.is/realms/leona/.well-known/openid-configuration";
        client_id = "fin.leona.is";
        server_hostname ="https://fin.leona.is";
        authMethod = "openid";
      };
    };
  };

  systemd.services.actual.serviceConfig.EnvironmentFile = [ config.sops.secrets."services/actual-budget/env".path ];

  services.nginx.virtualHosts."fin.leona.is" = {
    enableACME = true;
    forceSSL = true;
    kTLS = true;
    locations = {
      "/" = {
        recommendedProxySettings = true;
        proxyWebsockets = true;
        proxyPass = "http://[::1]:62441";
      };
    };
  };
}
