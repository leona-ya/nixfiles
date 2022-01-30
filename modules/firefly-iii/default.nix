{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.firefly-iii;
  package = pkgs.firefly-iii.override {
    dataDir = cfg.dataDir;
  };
  dataImporterPackage = pkgs.firefly-iii-data-importer.override {
    dataDir = cfg.data-importer.dataDir;
  };
in {
  options.services.firefly-iii = {
    enable = mkEnableOption "Firefly III";

    user = mkOption {
      default = "firefly-iii";
      description = "User Firefly III runs as.";
      type = types.str;
    };

    group = mkOption {
      default = "firefly-iii";
      description = "Group Firefly III runs as.";
      type = types.str;
    };

    frontendScheme = mkOption {
      description = "Whether the site is available via http or https. This does not configure https or ACME in nginx!";
      example = "https";
      type = types.enum [ "http" "https" ];
    };

    frontendHostname = mkOption {
      description = "The Hostname under which the frontend is running.";
      example = "finances.example.dev";
      type = types.str;
    };

    dataDir = mkOption {
      description = "Firefly III data directory";
      default = "/var/lib/firefly-iii";
      type = types.path;
    };

    poolConfig = mkOption {
      type = with types; attrsOf (oneOf [ str int bool ]);
      default = {
        "pm" = "dynamic";
        "pm.max_children" = 32;
        "pm.start_servers" = 2;
        "pm.min_spare_servers" = 2;
        "pm.max_spare_servers" = 4;
        "pm.max_requests" = 500;
      };
      description = ''
        Options for the Firefly III PHP pool. See the documentation on <literal>php-fpm.conf</literal>
        for details on configuration directives.
      '';
    };

    extraConfig = mkOption {
      type = types.nullOr types.lines;
      default = null;
      description = ''
        Lines to be appended verbatim to the Firefly III configuration.
        Refer to <link xlink:href="https://github.com/firefly-iii/firefly-iii/blob/main/.env.example"/> for details on supported values.
      '';
    };

    setupNginx = mkOption {
       description = "Setup nginx";
       default = true;
       type = types.bool;
    };

    data-importer = {
      enable = mkEnableOption "Firefly III Data Importer";
      dataDir = mkOption {
        description = "Firefly III Data Importer data directory";
        default = "/var/lib/firefly-iii/data-importer";
        type = types.str;
      };
      hostname = mkOption {
        description = "The Hostname under which the data-importer is running.";
        example = "data-importer.example.dev";
        type = types.str;
      };
      extraConfig = mkOption {
        type = types.nullOr types.lines;
        default = null;
        description = ''
          Lines to be appended verbatim to the Firefly III configuration.
          Refer to <link xlink:href="https://github.com/firefly-iii/data-importer/blob/main/.env.example"/> for details on supported values.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    services.phpfpm.pools.firefly-iii = {
      user = cfg.user;
      group = cfg.group;
      settings = {
        "listen.mode" = "0660";
        "listen.owner" = cfg.user;
        "listen.group" = cfg.group;
      } // cfg.poolConfig;
    };

    services.nginx = lib.mkIf cfg.setupNginx {
      enable = mkDefault true;
      virtualHosts = {
        "${cfg.frontendHostname}" = {
          root = "${package}/public";
          locations = {
            "/" = {
              index = "index.php";
              extraConfig = "try_files $uri $uri/ /index.php?$query_string;";
            };
            "~* \.php(?:$|/)" = {
              extraConfig = ''
                include ${pkgs.nginx}/conf/fastcgi_params;
                fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
                fastcgi_pass unix:${config.services.phpfpm.pools."firefly-iii".socket};
              '';
            };
          };
        };
        "${cfg.data-importer.hostname}" = lib.mkIf cfg.data-importer.enable {
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
    };

    systemd.services.firefly-iii-setup = {
      description = "Preperation tasks for Firefly III";
      before = [ "phpfpm-firefly-iii.service" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "oneshot";
        User = cfg.user;
        WorkingDirectory = package;
        PermissionsStartOnly = true;
      };
      preStart = ''
        mkdir -p ${cfg.dataDir}/storage/uploads
        chown -R ${cfg.user}:${cfg.group} ${cfg.dataDir}
        chmod -R ug+rwX,o-rwx ${cfg.dataDir}
      '';
      script = ''
        # set permissions
        umask 077
        # create .env file
        echo "
        APP_URL=${cfg.frontendScheme}://${cfg.frontendHostname}
        ${toString cfg.extraConfig}
        " > "${cfg.dataDir}/.env"

        # migrate db
        ${pkgs.php}/bin/php artisan migrate --seed --force

        # clear & create caches (needed in case of update)
        ${pkgs.php}/bin/php artisan cache:clear
        ${pkgs.php}/bin/php artisan firefly-iii:upgrade-database
        ${pkgs.php}/bin/php artisan passport:install
        ${pkgs.php}/bin/php artisan cache:clear
      '';
    };
    systemd.services.firefly-iii-data-impoter-setup = lib.mkIf cfg.data-importer.enable {
      description = "Preperation tasks for Firefly III Data Importer";
      before = [ "phpfpm-firefly-iii.service" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "oneshot";
        User = cfg.user;
        WorkingDirectory = package;
        PermissionsStartOnly = true;
      };
      preStart = ''
        mkdir -p ${cfg.data-importer.dataDir}/storage/uploads
        chown -R ${cfg.user}:${cfg.group} ${cfg.data-importer.dataDir}
        chmod -R ug+rwX,o-rwx ${cfg.data-importer.dataDir}
      '';
      script = ''
        # set permissions
        umask 077
        # create .env file
        echo "
        ${toString cfg.data-importer.extraConfig}
        " > "${cfg.data-importer.dataDir}/.env"

        ${pkgs.php}/bin/php artisan cache:clear
      '';
    };

    systemd.tmpfiles.rules = [
      "d ${cfg.dataDir}/storage/app 0700 ${cfg.user} ${cfg.group} - -"
      "d ${cfg.dataDir}/storage/fonts 0700 ${cfg.user} ${cfg.group} - -"
      "d ${cfg.dataDir}/storage/framework 0700 ${cfg.user} ${cfg.group} - -"
      "d ${cfg.dataDir}/storage/framework/sessions 0700 ${cfg.user} ${cfg.group} - -"
    ] ++ optionals cfg.data-importer.enable [
      "d ${cfg.data-importer.dataDir}/storage/app 0700 ${cfg.user} ${cfg.group} - -"
      "d ${cfg.data-importer.dataDir}/storage/fonts 0700 ${cfg.user} ${cfg.group} - -"
      "d ${cfg.data-importer.dataDir}/storage/framework 0700 ${cfg.user} ${cfg.group} - -"
      "d ${cfg.data-importer.dataDir}/storage/framework/sessions 0700 ${cfg.user} ${cfg.group} - -"
    ];
    systemd.services.firefly-iii-cron = {
      description = "Firefly III Cron";
      serviceConfig = {
        Type = "oneshot";
        User = cfg.user;
        WorkingDirectory = package;
        PermissionsStartOnly = true;
      };
      script = ''
        ${pkgs.php}/bin/php artisan firefly-iii:cron
      '';
    };
    systemd.timers.firefly-iii-cron = {
      timerConfig = {
        OnCalendar = "daily";
        RandomizedDelaySec = 1200;
      };
      wantedBy = [ "timers.target" ];
    };

    users = {
      users = mkIf (cfg.user == "firefly-iii") {
        firefly-iii = {
          group = cfg.group;
          isSystemUser = true;
        };
        "${config.services.nginx.user}".extraGroups = [ cfg.group ];
      };
      groups = mkIf (cfg.group == "firefly-iii") {
        firefly-iii = {};
      };
    };
  };

  meta.maintainers = with maintainers; [ em0lar ];
}
