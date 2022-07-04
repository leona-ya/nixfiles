{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.o.services.grocy;
in {
  imports = [
#    (mkRemovedOptionModule [ "o" "services" "grocy" "settings" "currency" ] "Use services.grocy.settings.CURRENCY instead.")
#    (mkRemovedOptionModule [ "o" "services" "grocy" "settings" "culture" ] "Use services.grocy.settings.CULTURE instead.")
#    (mkRemovedOptionModule [ "o" "services" "grocy" "settings" "calendar" "firstDayOfWeek" ] "Use services.grocy.settings.CALENDAR_FIRST_DAY_OF_WEEK instead.")
#    (mkRemovedOptionModule [ "o" "services" "grocy" "settings" "calendar" "showWeekNumber" ] "Use services.grocy.settings.CALENDAR_SHOW_WEEK_OF_YEAR instead.")
  ];

  options.o.services.grocy = {
    enable = mkEnableOption "grocy";

    hostName = mkOption {
      type = types.str;
      description = ''
        FQDN for the grocy instance.
      '';
    };

    nginx.enableSSL = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Whether or not to enable SSL (with ACME and let's encrypt)
        for the grocy vhost.
      '';
    };

    phpfpm.settings = mkOption {
      type = with types; attrsOf (oneOf [ int str bool ]);
      default = {
        "pm" = "dynamic";
        "php_admin_value[error_log]" = "stderr";
        "php_admin_flag[log_errors]" = true;
        "listen.owner" = "nginx";
        "catch_workers_output" = true;
        "pm.max_children" = "32";
        "pm.start_servers" = "2";
        "pm.min_spare_servers" = "2";
        "pm.max_spare_servers" = "4";
        "pm.max_requests" = "500";
      };

      description = ''
        Options for grocy's PHPFPM pool.
      '';
    };

    dataDir = mkOption {
      type = types.str;
      default = "/var/lib/grocy";
      description = ''
        Home directory of the <literal>grocy</literal> user which contains
        the application's state.
      '';
    };


    settings = mkOption {
      type = with types; attrsOf (oneOf [ str int bool ]);
      default = {};
      description = ''
        PHP-FPM pool directives. Refer to the "List of pool directives" section of
        <link xlink:href="https://www.php.net/manual/en/install.fpm.configuration.php"/>
        for details. Note that settings names must be enclosed in quotes (e.g.
        <literal>"pm.max_children"</literal> instead of <literal>pm.max_children</literal>).
      '';
      example = literalExpression ''
        {
          "pm" = "dynamic";
          "pm.max_children" = 75;
          "pm.start_servers" = 10;
          "pm.min_spare_servers" = 5;
          "pm.max_spare_servers" = 20;
          "pm.max_requests" = 500;
        }
      '';
    };
  };

  config = mkIf cfg.enable {
    o.services.grocy.settings = mkMerge [
      {
        "CURRENCY" = mkDefault "USD";
        "CULTURE" = mkDefault "en";
        "CALENDAR_SHOW_WEEK_OF_YEAR" = mkDefault true;
      }
    ];

    environment.etc."grocy/config.php".text = ''
      <?php
      ${concatStringsSep "\n" (mapAttrsToList (n: v: "Setting('${n}', ${builtins.toJSON v});") cfg.settings)}
    '';

    users.users.grocy = {
      isSystemUser = true;
      createHome = true;
      home = cfg.dataDir;
      group = "nginx";
    };

    systemd.tmpfiles.rules = map (
      dirName: "d '${cfg.dataDir}/${dirName}' - grocy nginx - -"
    ) [ "viewcache" "plugins" "settingoverrides" "storage" ];

    services.phpfpm.pools.grocy = {
      user = "grocy";
      group = "nginx";

      # PHP 8.0 is the only version which is supported/tested by upstream:
      # https://github.com/grocy/grocy/blob/v3.3.0/README.md#how-to-install
      phpPackage = pkgs.php80;

      inherit (cfg.phpfpm) settings;

      phpEnv = {
        GROCY_CONFIG_FILE = "/etc/grocy/config.php";
        GROCY_DB_FILE = "${cfg.dataDir}/grocy.db";
        GROCY_STORAGE_DIR = "${cfg.dataDir}/storage";
        GROCY_PLUGIN_DIR = "${cfg.dataDir}/plugins";
        GROCY_CACHE_DIR = "${cfg.dataDir}/viewcache";
      };
    };

    services.nginx = {
      enable = true;
      virtualHosts."${cfg.hostName}" = mkMerge [
        {
          root = "${pkgs.grocy}/public";
          locations."/".extraConfig = ''
            rewrite ^ /index.php;
          '';
          locations."~ \\.php$".extraConfig = ''
            fastcgi_split_path_info ^(.+\.php)(/.+)$;
            fastcgi_pass unix:${config.services.phpfpm.pools.grocy.socket};
            include ${config.services.nginx.package}/conf/fastcgi.conf;
            include ${config.services.nginx.package}/conf/fastcgi_params;
          '';
          locations."~ \\.(js|css|ttf|woff2?|png|jpe?g|svg)$".extraConfig = ''
            add_header Cache-Control "public, max-age=15778463";
            add_header X-Content-Type-Options nosniff;
            add_header X-XSS-Protection "1; mode=block";
            add_header X-Robots-Tag none;
            add_header X-Download-Options noopen;
            add_header X-Permitted-Cross-Domain-Policies none;
            add_header Referrer-Policy no-referrer;
            access_log off;
          '';
          extraConfig = ''
            try_files $uri /index.php;
          '';
        }
        (mkIf cfg.nginx.enableSSL {
          enableACME = true;
          forceSSL = true;
        })
      ];
    };
  };

  meta = {
    maintainers = with maintainers; [ ma27 ];
#    doc = ./grocy.xml;
  };
}
