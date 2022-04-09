{ config, lib, ... }:

{
  l.sops.secrets = {
    "services/paperless-ng/env".owner = "root";
    "services/paperless-ng/vouch_proxy_env".owner = "root";
  };

  services.paperless-ng = {
    enable = true;
    extraConfig = {
      PAPERLESS_ENABLE_HTTP_REMOTE_USER = true;
      PAPERLESS_HTTP_REMOTE_USER_HEADER_NAME = "HTTP_X_AUTH_REMOTE_USER";
      PAPERLESS_DBHOST = "/run/postgresql";
      PAPERLESS_CORS_ALLOWED_HOSTS = "https://paperless.leona.is";
      PAPERLESS_OCR_LANGUAGE = "deu+eng";
    };
  };

  systemd.services = {
    paperless-ng-server = {
      serviceConfig = {
        EnvironmentFile = config.sops.secrets."services/paperless-ng/env".path;
        PrivateNetwork = lib.mkForce false;
      };
    };
    paperless-ng-consumer = {
      serviceConfig.EnvironmentFile = config.sops.secrets."services/paperless-ng/env".path;
    };
    paperless-ng-web = {
      unitConfig.JoinsNamespaceOf = "paperless-ng-server.service";
      serviceConfig = {
        EnvironmentFile = config.sops.secrets."services/paperless-ng/env".path;
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

  services.nginx.virtualHosts."paperless.leona.is" = {
    enableACME = true;
    forceSSL = true;
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
    servers."paperless.leona.is" = {
      clientId = "paperless";
      port = 12300;
      environmentFiles = [ config.sops.secrets."services/paperless-ng/vouch_proxy_env".path ];
    };
  };
}
