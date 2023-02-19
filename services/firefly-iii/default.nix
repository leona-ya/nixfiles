{ pkgs, config, lib, ... }:

let
  cfg = config.services.firefly-iii;
  package = pkgs.firefly-iii.override {
    dataDir = cfg.dataDir;
  };
  dataImporterPackage = pkgs.firefly-iii-data-importer.override {
    dataDir = cfg.data-importer.dataDir;
  };
in {
  l.sops.secrets = {
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
    appKeyFile = config.sops.secrets."services/firefly-iii/app_key".path;
    hostname = "fin.leona.is";
    nginx.addSSL = true;
    database = {
      type = "pgsql";
      host = "/run/postgresql";
      port = 5432;
      name = "firefly-iii";
    };
    mail = {
      driver = "smtp";
      host = "mail.leona.is";
      port = 587;
      user = "no-reply@leona.is";
      passwordFile = config.sops.secrets."all/mail/no_reply_password".path;
      encryption = "tls";
    };
    config = {
      TZ = "Europe/Berlin";
      AUTHENTICATION_GUARD = "remote_user_guard";
      AUTHENTICATION_GUARD_HEADER = "HTTP_X_VOUCH_USERNAME";
      AUTHENTICATION_GUARD_EMAIL = "HTTP_X_VOUCH_EMAIL";
      TRUSTED_PROXIES = "**";
    };
  };

  services.nginx.virtualHosts = {
    "firefly-iii-internal" = {
      listen = [
        {
          addr = "[::1]";
          port = 8212;
        }
      ];
      root = "${package}/public";
      locations = {
        "/" = {
          index = "index.php";
          tryFiles = "$uri $uri/ /index.php?$query_string";
        };
        "~ \.php".extraConfig = ''
          include ${pkgs.nginx}/conf/fastcgi_params;
          fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
          fastcgi_pass unix:${config.services.phpfpm.pools."firefly-iii".socket};
        '';
        "~ \.(js|css|gif|png|ico|jpg|jpeg)$" = {
          extraConfig = "expires 365d;";
        };
      };
    };
    "fin.leona.is" = {
      enableACME = true;
      forceSSL = true;
      kTLS = true;
      locations."/" = {
        proxyPass = "http://[::1]:8212";
        extraConfig = ''
          auth_request_set $auth_resp_x_vouch_email $upstream_http_x_vouch_user;
          auth_request_set $auth_resp_x_vouch_username $upstream_http_x_vouch_idp_claims_preferred_username;
          proxy_set_header X-Vouch-Email $auth_resp_x_vouch_email;
          proxy_set_header X-Vouch-Username $auth_resp_x_vouch_username;
        '';
      };
    };
  };

  services.vouch-proxy = {
    enable = true;
    servers."fin.leona.is" = {
      clientId = "firefly-iii";
      port = 12300;
      environmentFiles = [ config.sops.secrets."services/firefly-iii/vouch_proxy_env".path ];
    };
  };
}

