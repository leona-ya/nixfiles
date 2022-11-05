{ pkgs, lib, config, ... }:

let
  grafanaDomain = "grafana.leona.is";

in {
  l.sops.secrets."services/monitoring/grafana/env".owner = "grafana";
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
    settings = {
      server = {
        protocol = "socket";
        rootUrl = "https://${grafanaDomain}/";
        domain = grafanaDomain;
      };
      database = {
        type = "postgres";
        user = "grafana";
        host = "/run/postgresql";
      };
      "auth.generic_oauth" = {
        enabled = true;
        name = "Keycloak";
        client_id = "grafana";
        allow_sign_up = true;
        auth_url = "https://auth.em0lar.dev/auth/realms/em0lar/protocol/openid-connect/auth";
        token_url = "https://auth.em0lar.dev/auth/realms/em0lar/protocol/openid-connect/token";
        api_url = "https://auth.em0lar.dev/auth/realms/em0lar/protocol/openid-connect/userinfo";
        role_attribute_path = "contains(roles[*], 'admin') && 'Admin' || contains(roles[*], 'editor') && 'Editor' || 'Viewer'";
        scopes =  "openid profile email";
        email_attribute_names = "email:primary";
      };
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
    EnvironmentFile = config.sops.secrets."services/monitoring/grafana/env".path;
  };

  users.users.nginx.extraGroups = [ "grafana" ];
  services.nginx.virtualHosts.${grafanaDomain} = {
    locations."/" = {
      proxyPass = "http://unix:${toString config.services.grafana.socket}";
      proxyWebsockets = true;
    };
    enableACME = true;
    forceSSL = true;
    kTLS = true;
  };
}
