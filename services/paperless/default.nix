{ config, lib, ... }:

{
  l.sops.secrets = {
    "services/paperless/env".owner = "root";
    "services/paperless/vouch_proxy_env".owner = "root";
  };

  services.paperless = {
    enable = true;
    extraConfig = {
      PAPERLESS_ENABLE_HTTP_REMOTE_USER = true;
      PAPERLESS_HTTP_REMOTE_USER_HEADER_NAME = "HTTP_X_AUTH_REMOTE_USER";
      PAPERLESS_DBHOST = "/run/postgresql";
      PAPERLESS_CORS_ALLOWED_HOSTS = "https://paperless.leona.is";
      PAPERLESS_OCR_LANGUAGE = "deu+eng";
      PAPERLESS_TASK_WORKERS = 2;
      PAPERLESS_THREADS_PER_WORKER = 1;
      PAPERLESS_TIME_ZONE = config.time.timeZone;
    };
  };

  systemd.services = {
    paperless-scheduler.serviceConfig = {
      EnvironmentFile = config.sops.secrets."services/paperless/env".path;
      PrivateNetwork = lib.mkForce false;
      after = [ "postgresql.service" ];
    };
    paperless-consumer.serviceConfig.EnvironmentFile = config.sops.secrets."services/paperless/env".path;
    paperless-web = {
      serviceConfig = {
        EnvironmentFile = config.sops.secrets."services/paperless/env".path;
      };
    };
  };

  services.postgresql = {
    enable = true;
    ensureDatabases = [ "paperless" ];
    ensureUsers = [
      { name = "paperless";
        ensurePermissions."DATABASE paperless" = "ALL PRIVILEGES";
      }
    ];
  };

  security.acme.certs."paperless.int.leona.is".server = "https://acme.int.leona.is/acme/acme/directory";
  
  services.nginx.virtualHosts."paperless.int.leona.is" = {
    enableACME = true;
    forceSSL = true;
    kTLS = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:28981";
      proxyWebsockets = true;
      extraConfig = ''
        auth_request_set $auth_resp_x_vouch_email $upstream_http_x_vouch_user;
        auth_request_set $auth_resp_x_vouch_username $upstream_http_x_vouch_idp_claims_preferred_username;
        proxy_set_header X-Auth-Remote-User $auth_resp_x_vouch_username;
      '';
    };
  };

  services.vouch-proxy = {
    enable = true;
    servers."paperless.int.leona.is" = {
      clientId = "paperless";
      port = 12300;
      environmentFiles = [ config.sops.secrets."services/paperless/vouch_proxy_env".path ];
    };
  };
}
