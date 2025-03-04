{ lib, config, pkgs, ... }:

{
  l.sops.secrets = {
    "services/matrix/synapse/secrets.yaml".owner = "matrix-synapse";
    "services/matrix/synapse/homeserver_signing_key".owner = "matrix-synapse";
  };

  services.postgresql = {
    enable = true;
    ensureUsers = [
      { name = "matrix-synapse"; }
    ];
    initialScript = pkgs.writeText "synapse-init.sql" ''
      CREATE DATABASE "matrix-synapse" WITH OWNER "matrix-synapse"
       ENCODING 'UTF8'
       TEMPLATE template0
       LC_COLLATE = "C"
       LC_CTYPE = "C";
    '';
  };

  #  users.users.matrix-synapse.extraGroups = [ "mautrix-telegram" ];

  services.matrix-synapse = {
    enable = true;

    settings = {
      enable_registration = false;
      server_name = "leona.is";
      public_baseurl = "https://matrix.leona.is:443/";

      database_type = "psycopg2";
      database_args = {
        database = "matrix-synapse";
      };

      listeners = [
        {
          bind_addresses = [ "::1" ];
          port = 8008;
          resources = [
            { names = [ "client" ]; compress = true; }
            { names = [ "federation" ]; compress = false; }
          ];
          type = "http";
          tls = false;
          x_forwarded = true;
        }
      ];
      url_preview_enabled = false;
      log_config = pkgs.writeText "matrix-synapse-log-config" ''
        version: 1
        formatters:
          precise:
            format: '%(asctime)s - %(name)s - %(lineno)d - %(levelname)s - %(request)s - %(message)s'
        filters:
          context:
            (): synapse.util.logcontext.LoggingContextFilter
            request: ""
        handlers:
          console:
            class: logging.StreamHandler
            formatter: precise
            filters: [context]
        loggers:
          synapse:
            level: INFO
          synapse.storage.SQL:
            # beware: increasing this to DEBUG will make synapse log sensitive
            # information such as access tokens.
            level: WARNING
        root:
          level: INFO
          handlers: [console]
      '';
    };
    extraConfigFiles = [
      config.sops.secrets."services/matrix/synapse/secrets.yaml".path
    ];
  };

  services.synapse-auto-compressor = {
    enable = true;
  };

  systemd.services.matrix-synapse.serviceConfig.ExecStartPre = [
    "${pkgs.coreutils}/bin/ln -sf ${config.sops.secrets."services/matrix/synapse/homeserver_signing_key".path} ${config.services.matrix-synapse.dataDir}/homeserver.signing.key"
  ];

  services.nginx.virtualHosts."matrix.leona.is" = {
    enableACME = true;
    forceSSL = true;
    kTLS = true;
    locations = {
      "/" = {
        proxyPass = "http://[::1]:8008";
        extraConfig = ''
          client_max_body_size 55M;
        '';
      };
    };
  };
}
