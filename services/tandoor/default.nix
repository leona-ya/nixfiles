{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = {
    l.sops.secrets = {
      "services/tandoor/oidc_secret" = { };
      "services/tandoor/secret_key" = { };
    };

    sops.templates."tandoor-socialaccount-providers" = {
      content = builtins.toJSON {
        openid_connect = {
          OAUTH_PKCE_ENABLED = "True";
          APPS = [
            {
              provider_id = "keycloak";
              name = "leona's SSO";
              client_id = "nomsable.eu";
              secret = config.sops.placeholder."services/tandoor/oidc_secret";
              settings.server_url = "https://auth.leona.is/realms/leona/.well-known/openid-configuration";
            }
          ];
        };
      };
    };

    services.postgresql = {
      enable = true;
      ensureUsers = [
        {
          name = "tandoor";
          ensureDBOwnership = true;
        }
      ];
      ensureDatabases = [
        "tandoor"
      ];
    };

    systemd.services.nginx.serviceConfig.SupplimentaryGroups = [ "tandoor" ];

    services.nginx = {
      enable = true;
      virtualHosts."nomsable.eu" = {
        enableACME = true;
        forceSSL = true;
        kTLS = true;
        locations."/" = {
          proxyPass = "http://${config.services.tandoor-recipes.address}:${toString config.services.tandoor-recipes.port}";
          recommendedProxySettings = true;
        };
        locations."/media/".alias = "/var/lib/tandoor-recipes/";
        locations."= /metrics" = {
          return = "404";
        };
      };
    };

    services.vmagent.prometheusConfig.scrape_configs = [
      {
        job_name = "tandoor";
        metrics_path = "/metrics";
        static_configs = [
          {
            targets = [
              "${config.services.tandoor-recipes.address}:${toString config.services.tandoor-recipes.port}"
            ];
          }
        ];
      }
    ];

    services.tandoor-recipes = {
      enable = false;
      package = pkgs.tandoor-recipes.overridePythonAttrs (old: {
        propagatedBuildInputs =
          old.propagatedBuildInputs
          ++ (with pkgs.python3Packages; [
            jwt
            django-debug-toolbar
          ]);
      });
      user = "tandoor";
      group = "tandoor";
      extraConfig = {
        DEBUG = 1;
        SECRET_KEY_FILE = "/run/credentials/tandoor-recipes.service/secret_key";
        LOG_LEVEL = "DEBUG";
        GUNICORN_LOG_LEVEL = "debug";
        SOCIAL_PROVIDERS = "allauth.socialaccount.providers.openid_connect";
        SOCIALACCOUNT_ONLY = true;

        DB_ENGINE = "django.db.backends.postgresql";
        POSTGRES_DB = "tandoor";

        SORT_TREE_BY_NAME = true;

        SOCIAL_DEFAULT_ACCESS = 1;
        SOCIAL_DEFAULT_GROUP = "user";
      };
    };

    users.users.tandoor = {
      group = "tandoor";
      isSystemUser = true;
    };
    users.groups.tandoor = { };

    systemd.services.tandoor-recipes = {
      serviceConfig = {
        ExecStart = lib.mkForce (
          pkgs.writeShellScript "start" ''
            export SOCIALACCOUNT_PROVIDERS=$(< ''${CREDENTIALS_DIRECTORY}/socialaccount-providers)
            ${config.services.tandoor-recipes.package.python.pkgs.gunicorn}/bin/gunicorn recipes.wsgi
          ''
        );
        LoadCredential = [
          "socialaccount-providers:${config.sops.templates.tandoor-socialaccount-providers.path}"
          "secret_key:${config.sops.secrets."services/tandoor/secret_key".path}"
        ];
        BindReadOnlyPaths = [
          config.sops.templates.tandoor-socialaccount-providers.path
          config.sops.secrets."services/tandoor/secret_key".path
        ];
        #        DynamicUser = true;
        #        UMask = lib.mkForce "0077";
      };
    };
  };
}
