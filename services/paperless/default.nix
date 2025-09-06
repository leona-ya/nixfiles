{ config, lib, ... }:

{
  l.sops.secrets = {
    "services/paperless/env".owner = "root";
    "services/paperless/vouch_proxy_env".owner = "root";
  };

  services.paperless = {
    enable = true;
    settings = {
      PAPERLESS_ENABLE_HTTP_REMOTE_USER = true;
      PAPERLESS_HTTP_REMOTE_USER_HEADER_NAME = "HTTP_X_AUTH_REMOTE_USER";
      PAPERLESS_DBHOST = "/run/postgresql";
      PAPERLESS_URL = "https://paperless.int.leona.is";
      PAPERLESS_OCR_LANGUAGE = "deu+eng";
      PAPERLESS_TASK_WORKERS = 2;
      PAPERLESS_THREADS_PER_WORKER = 2;
      PAPERLESS_TIME_ZONE = config.time.timeZone;
      PAPERLESS_CONSUMER_ENABLE_ASN_BARCODE = true;
      PAPERLESS_CONSUMER_BARCODE_UPSCALE = 1.5;
      PAPERLESS_CONSUMER_BARCODE_DPI = 600;
    };
  };

  systemd.services = {
    paperless-scheduler = {
      after = [ "postgresql.service" ];
      serviceConfig.EnvironmentFile = config.sops.secrets."services/paperless/env".path;
    };
    paperless-consumer.serviceConfig.EnvironmentFile =
      config.sops.secrets."services/paperless/env".path;
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
      {
        name = "paperless";
        ensureDBOwnership = true;
      }
    ];
  };

  security.acme.certs."paperless.int.leona.is".group = "nginx";

  services.nginx.virtualHosts."paperless.int.leona.is" = {
    useACMEHost = "paperless.int.leona.is";
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
