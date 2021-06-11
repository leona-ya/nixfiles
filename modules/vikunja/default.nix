{ pkgs, lib, config, ... }:

with lib;

let
  cfg = config.services.vikunja;
  configFile = pkgs.writeText "config.json" (
    builtins.toJSON (
      cfg.config // cfg.extraConfig // {
        service.frontendurl = "${cfg.frontendScheme}://${cfg.frontendHostname}";
        }
   ));
  useMysql = cfg.config.database.type == "mysql";
  usePostgresql = cfg.config.database.type == "postgres";
in {
  options.services.vikunja = with lib; {
    enable = mkEnableOption "Enable Vikunja service";
    package-api = mkOption {
      default = pkgs.vikunja-api;
      type = types.package;
      defaultText = "pkgs.vikunja-api";
      description = "vikunja-api derivation to use";
    };
    package-frontend = mkOption {
      default = pkgs.vikunja-frontend;
      type = types.package;
      defaultText = "pkgs.vikunja-frontend";
      description = "vikunja-frontend derivation to use";
    };
    user = mkOption {
      type = types.str;
      default = "vikunja";
      description = "User account under which vikunja runs. The user will only be created when using the default.";
    };
    stateDir = mkOption {
      type = types.str;
      default = "/var/lib/vikunja";
      description = "Vikunja data directory";
    };
    environmentFiles = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = "Files";
    };
    setupNginx = mkOption {
      type = types.bool;
      default = config.services.nginx.enable;
      description = "Whether to setup NGINX.";
    };
    frontendScheme = mkOption {
      type = types.enum [ "http" "https" ];
      description = "Whether the site is available via http or https. This does not configure https or ACME in nginx!";
    };
    frontendHostname = mkOption {
      type = types.str;
      description = "The Hostname under which the frontend is running.";
    };
    extraConfig = mkOption {
      type = types.attrs;
      default = {};
      description = "Extra config that fill directly be passed into the Vikunja config.";
    };
    config = {
      service = {
        timezone = mkOption {
          type = types.str;
          example = "Europe/Berlin";
          default = "UTC";
          description = "Time zone for all timestamps. Should be a tz database name.";
        };
      };
      database = {
        type = mkOption {
          type = types.enum [ "sqlite" "mysql" "postgres" ];
          example = "postgres";
          default = "sqlite";
          description = "Database engine to use.";
        };
        host = mkOption {
          type = types.str;
          default = "localhost";
          description = "Database host address. Can also be a socket.";
        };
        user = mkOption {
          type = types.str;
          default = "vikunja";
          description = "Database user.";
        };
        password = mkOption {
          type = types.str;
          default = "";
          description = ''
            Database password <option>config.database.user</option>.
            Warning: this is stored in cleartext in the Nix store!
            Use an environment file with <option>environmentFiles</option> instead.
          '';
        };
        database = mkOption {
          type = types.str;
          default = "vikunja";
          description = "Database name.";
        };
        path = mkOption {
          type = types.str;
          default = "${cfg.stateDir}/vikunja.db";
          description = "Path to the sqlite3 database file.";
        };
        createDatabase = mkOption {
          type = types.bool;
          default = true;
          description = "Whether to create a local database automatically.";
        };
      };
      corsOrigins = mkOption {
        type = types.listOf types.str;
        default = [];
      };
      mailer = {
        enabled = mkOption {
          type = types.bool;
          default = false;
          description = "Whether mailer should be enabled.";
        };
        host = mkOption {
          type = types.str;
          default = "";
          description = "SMTP host address.";
        };
        port = mkOption {
          type = types.int;
          default = 587;
          description = "SMTP host port.";
        };
        username = mkOption {
          type = types.str;
          default = "";
          description = "SMTP username.";
        };
        password = mkOption {
          type = types.str;
          default = "";
          description = ''
            SMTP User password <option>config.database.user</option>.
            Warning: this is stored in cleartext in the Nix store!
            Use an environment file with <option>environmentFiles</option> instead.
          '';
        };
        fromemail = mkOption {
          type = types.str;
          default = "";
          description = "The default from address when sending emails.";
        };
        forcessl = mkOption {
          type = types.bool;
          default = false;
          description = "By default, vikunja will try to connect with starttls, use this option to force it to use ssl.";
        };
      };
    };
  };
  config = lib.mkIf cfg.enable {

    systemd.services.vikunja-api = {
      description = "vikunja-api";
      after = [ "network.target" ] ++ lib.optional usePostgresql "postgresql.service" ++ lib.optional useMysql "mysql.service";
      wantedBy = [ "multi-user.target" ];
      path = [ cfg.package-api ];


      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        Group = "vikunja";
        WorkingDirectory = cfg.stateDir;
        ExecStart = "${cfg.package-api}/bin/api";
        Restart = "always";
        EnvironmentFile = cfg.environmentFiles;
      };
    };

    services.nginx.virtualHosts."${cfg.frontendHostname}" = {
      locations = {
        "/" = {
          root = cfg.package-frontend;
          tryFiles = "try_files $uri $uri/ /";
        };
        "~* ^/(api|dav|\.well-known)/" = {
          proxyPass = "http://localhost:3456";
          extraConfig = ''
            client_max_body_size 20M;
          '';
        };
      };
    };

    users.users = mkIf (cfg.user == "vikunja") {
      vikunja = {
        description = "Vikunja Service";
        home = cfg.stateDir;
        createHome = true;
        useDefaultShell = true;
        group = "vikunja";
        isSystemUser = true;
      };
    };

    users.groups.vikunja = {};

    environment.etc."vikunja/config.json".source = configFile;

    services.postgresql = optionalAttrs (usePostgresql && cfg.config.database.createDatabase) {
      enable = mkDefault true;

      ensureDatabases = [ cfg.config.database.database ];
      ensureUsers = [
        { name = cfg.config.database.user;
          ensurePermissions = { "DATABASE ${cfg.config.database.database}" = "ALL PRIVILEGES"; };
        }
      ];
    };

    services.mysql = optionalAttrs (useMysql && cfg.config.database.createDatabase) {
      enable = mkDefault true;
      package = mkDefault pkgs.mariadb;

      ensureDatabases = [ cfg.config.database.database ];
      ensureUsers = [
        { name = cfg.config.database.user;
          ensurePermissions = { "${cfg.config.database.database}.*" = "ALL PRIVILEGES"; };
        }
      ];
    };
  };
}
