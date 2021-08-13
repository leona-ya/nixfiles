{ pkgs, lib, config, ... }:

let
  grafanaDomain = "grafana.em0lar.dev";

in {
  em0lar.secrets."grafana_oauth_client_secret".owner = "grafana";
  services.postgresql = {
    enable = true;
    ensureDatabases = [ "grafana" ];
    ensureUsers = [
      { name = "grafana";
        ensurePermissions."DATABASE grafana" = "ALL PRIVILEGES";
      }
    ];
  };
  services.grafana = {
    enable = true;
    protocol = "socket";

    rootUrl = "https://${grafanaDomain}/";
    domain = grafanaDomain;

    database = {
      type = "postgres";
      user = "grafana";
      host = "/run/postgresql";
    };

    extraOptions = {
      AUTH_GENERIC_OAUTH_ENABLED = "true";
      AUTH_GENERIC_OAUTH_NAME = "Keycloak";
      AUTH_GENERIC_OAUTH_CLIENT_ID = "grafana";
      AUTH_GENERIC_OAUTH_ALLOW_SIGN_UP = "true";
      AUTH_GENERIC_OAUTH_AUTH_URL = "https://auth.em0lar.dev/auth/realms/em0lar/protocol/openid-connect/auth";
      AUTH_GENERIC_OAUTH_TOKEN_URL = "https://auth.em0lar.dev/auth/realms/em0lar/protocol/openid-connect/token";
      AUTH_GENERIC_OAUTH_API_URL = "https://auth.em0lar.dev/auth/realms/em0lar/protocol/openid-connect/userinfo";
      AUTH_GENERIC_OAUTH_ROLE_ATTRIBUTE_PATH = "contains(roles[*], 'admin') && 'Admin' || contains(roles[*], 'editor') && 'Editor' || 'Viewer'";
      AUTH_GENERIC_OAUTH_SCOPES = "openid profile email";
      AUTH_GENERIC_OAUTH_EMAIL_ATTRIBUTE_NAMEs = "email:primary";
    };

    declarativePlugins = with pkgs.grafanaPlugins; [
      grafana-piechart-panel
    ];

    provision = {
      enable = true;
      datasources = [
        {
          type = "prometheus";
          name = "Prometheus";
          url = "http://[::1]:${toString config.services.prometheus.port}/";
          isDefault = true;
        }
      ];
      dashboards = [
        { options.path = ./dashboards; }
      ];
    };
  };
  systemd.services.grafana.serviceConfig = {
    EnvironmentFile = config.em0lar.secrets.grafana_oauth_client_secret.path;
  };

  users.users.nginx.extraGroups = [ "grafana" ];
  services.nginx.virtualHosts.${grafanaDomain} = {
    locations."/" = {
      proxyPass = "http://unix:${toString config.services.grafana.socket}";
      proxyWebsockets = true;
    };
    enableACME = true;
    forceSSL = true;
  };
}
