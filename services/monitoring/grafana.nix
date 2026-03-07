{
  pkgs,
  lib,
  config,
  ...
}:

let
  grafanaDomain = "grafana.mon.leona.is";

in
{
  l.sops.secrets."services/monitoring/grafana/oauth_client_secret".owner = "grafana";
  l.sops.secrets."services/monitoring/grafana/secret_key".owner = "grafana";
  services.postgresql = {
    enable = true;
    ensureDatabases = [ "grafana" ];
    ensureUsers = [
      {
        name = "grafana";
        ensureDBOwnership = true;
      }
    ];
  };
  services.grafana = {
    enable = true;
    settings = {
      security.secret_key = "$__file{${
        config.sops.secrets."services/monitoring/grafana/secret_key".path
      }}";
      server = {
        protocol = "socket";
        root_url = "https://${grafanaDomain}/";
        domain = grafanaDomain;
      };
      database = {
        type = "postgres";
        user = "grafana";
        host = "/run/postgresql";
      };
      "auth.generic_oauth" = {
        enabled = true;
        allow_sign_up = true;
        api_url = "https://auth.leona.is/realms/leona/protocol/openid-connect/userinfo";
        auth_url = "https://auth.leona.is/realms/leona/protocol/openid-connect/auth";
        client_id = "grafana";
        client_secret = "$__file{${
          config.sops.secrets."services/monitoring/grafana/oauth_client_secret".path
        }}";
        email_attribute_names = "email:primary";
        name = "Keycloak";
        role_attribute_path = "contains(roles[*], 'admin') && 'Admin' || contains(roles[*], 'editor') && 'Editor' || 'Viewer'";
        scopes = "openid profile email roles";
        token_url = "https://auth.leona.is/realms/leona/protocol/openid-connect/token";
      };
    };

    declarativePlugins = with pkgs.grafanaPlugins; [
      grafana-piechart-panel
      victoriametrics-logs-datasource
    ];

    provision = {
      enable = true;
      datasources.settings = {
        apiVersion = 1;
        datasources = [
          {
            name = "VictoriaMetrics";
            type = "prometheus";
            url = "https://metrics.mon.leona.is";
            isDefault = true;
            jsonData = {
              tlsAuth = true;
              serverName = "metrics.mon.leona.is";
            };
            secureJsonData = {
              tlsClientCert = "$__file{/var/lib/acme/${grafanaDomain}/fullchain.pem}";
              tlsClientKey = "$__file{/var/lib/acme/${grafanaDomain}/key.pem}";
            };
          }
          {
            name = "VictoriaLogs";
            type = "victoriametrics-logs-datasource";
            url = "https://logs.mon.leona.is";
            access = "proxy";
            isDefault = false;
            jsonData = {
              tlsAuth = true;
              serverName = "logs.mon.leona.is";
            };
            secureJsonData = {
              tlsClientCert = "$__file{/var/lib/acme/${grafanaDomain}/fullchain.pem}";
              tlsClientKey = "$__file{/var/lib/acme/${grafanaDomain}/key.pem}";
            };
          }
        ];
      };
      dashboards.settings = {
        apiVersion = 1;
        providers = [
          {
            name = "nix provisioned";
            options.path = ./dashboards;
          }
        ];
      };
    };
  };

  security.acme.certs."${grafanaDomain}" = {
    group = "grafana";
    profile = "tlsclient";
  };

  users.users.nginx.extraGroups = [ "grafana" ];
  services.nginx.virtualHosts.${grafanaDomain} = {
    locations."/" = {
      proxyPass = "http://unix:${toString config.services.grafana.settings.server.socket}";
      proxyWebsockets = true;
    };
    enableACME = true;
    forceSSL = true;
    kTLS = true;
  };
}
