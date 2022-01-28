{ pkgs, config, lib, ... }:

{
  em0lar.sops.secrets = {
    "all/mail/no_reply_password" = {
      owner = "firefly-iii";
      group = "firefly-iii";
    };
    "services/firefly-iii/app_key" = {
      owner = "firefly-iii";
      group = "firefly-iii";
    };
    "services/firefly-iii/vouch_proxy_env" = {
      owner = "firefly-iii";
      group = "firefly-iii";
    };
  };

  services.postgresql = {
    enable = true;
    ensureDatabases = [ "firefly-iii" ];
    ensureUsers = [
      { name = "firefly-iii";
        ensurePermissions."DATABASE \"firefly-iii\"" = "ALL PRIVILEGES";
      }
    ];
  };

  services.firefly-iii = {
    enable = true;
    frontendScheme = "https";
    frontendHostname = "fin.em0lar.dev";
    extraConfig = ''
      APP_ENV=local
      SITE_OWNER=noc@em0lar.dev
      APP_KEY=j6nAuq4JN3K4E8Gg6389yVusRckz4Zqt
      APP_KEY_FILE=${config.sops.secrets."services/firefly-iii/app_key".path}
      TZ=Europe/Berlin
      DB_CONNECTION=pgsql
      DB_HOST=/run/postgresql
      DB_PORT=5432
      DB_DATABASE=firefly-iii
      DB_USERNAME=firefly-iii
      AUTHENTICATION_GUARD=remote_user_guard
      AUTHENTICATION_GUARD_HEADER=HTTP_X_VOUCH_USERNAME
      AUTHENTICATION_GUARD_EMAIL=HTTP_X_VOUCH_EMAIL
    '';
#    MAIL_MAILER=log
#    MAIL_HOST=null
#    MAIL_PORT=2525
#    MAIL_FROM=changeme@example.com
#    MAIL_USERNAME=null
#    MAIL_PASSWORD=null
#    MAIL_ENCRYPTION=null
  };

  services.nginx.virtualHosts = {
    "fin.em0lar.dev" = {
      enableACME = true;
      forceSSL = true;
      locations."~* \.php(?:$|/)".extraConfig = ''
        auth_request /_vouch/validate;
        auth_request_set $auth_resp_x_vouch_email $upstream_http_x_vouch_user;
        auth_request_set $auth_resp_x_vouch_username $upstream_http_x_vouch_idp_claims_preferred_username;
        fastcgi_param HTTP_X_VOUCH_EMAIL $auth_resp_x_vouch_email;
        fastcgi_param HTTP_X_VOUCH_USERNAME $auth_resp_x_vouch_username;
      '';
    };

  };

  services.vouch-proxy = {
    enable = true;
    servers."fin.em0lar.dev" = {
      clientId = "firefly-iii";
      port = 12300;
      environmentFiles = [ config.sops.secrets."services/firefly-iii/vouch_proxy_env".path ];
    };
  };
}

