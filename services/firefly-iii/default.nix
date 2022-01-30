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
    setupNginx = false;
    extraConfig = ''
      TRUSTED_PROXIES=**
      APP_LOG_LEVEL=warning
      APP_ENV=local
      SITE_OWNER=noc@em0lar.dev
      APP_KEY=TRKPVh8T3jdyGZWzF8vmACrXte4WqfU6
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
    data-importer = {
      enable = true;
      hostname = "dataimporter.fin.em0lar.dev";
      extraConfig = ''
        FIREFLY_III_URL=http://[fd8f:d15b:9f40:c31:5054:ff:fee7:6ae5]:8212
        VANITY_URL=https://fin.em0lar.dev
        FIREFLY_III_CLIENT_ID=65
      '';
    };
  };

  services.nginx.virtualHosts = {
    "firefly-iii-internal" = {
      listen = [
        {
          addr = "[fd8f:d15b:9f40:c31:5054:ff:fee7:6ae5]";
          port = 8212;
        }
      ];
      root = "${package}/public";
      locations = {
        "/" = {
          index = "index.php";
          tryFiles = "$uri $uri/ /index.php?$query_string";
        };
        "~* \.php(?:$|/)".extraConfig = ''
          include ${pkgs.nginx}/conf/fastcgi_params;
          fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
          fastcgi_pass unix:${config.services.phpfpm.pools."firefly-iii".socket};
        '';
      };
    };
    "fin.em0lar.dev" = {
      enableACME = true;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://[fd8f:d15b:9f40:c31:5054:ff:fee7:6ae5]:8212";
        extraConfig = ''
          auth_request_set $auth_resp_x_vouch_email $upstream_http_x_vouch_user;
          auth_request_set $auth_resp_x_vouch_username $upstream_http_x_vouch_idp_claims_preferred_username;
          proxy_set_header X-Vouch-Email $auth_resp_x_vouch_email;
          proxy_set_header X-Vouch-Username $auth_resp_x_vouch_username;
        '';
      };
    };
    "dataimporter.fin.em0lar.dev" = lib.mkIf cfg.data-importer.enable {
      enableACME = true;
      forceSSL = true;
      root = "${dataImporterPackage}/public";
      locations = {
        "/" = {
          index = "index.php";
          extraConfig = "try_files $uri $uri/ /index.php?$query_string;";
        };
        "~* \.php(?:$|/)" = {
          extraConfig = ''
            include ${pkgs.nginx}/conf/fastcgi_params;
            fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
            fastcgi_param modHeadersAvailable true;
            fastcgi_buffers 16 16k;
            fastcgi_buffer_size 32k;
            fastcgi_pass unix:${config.services.phpfpm.pools."firefly-iii".socket};
          '';
        };
      };
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

