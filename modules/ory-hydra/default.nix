{ pkgs, lib, config, ... }:

with lib;

let
  cfg = config.services.ory-hydra;
  format = pkgs.formats.yaml { };
  configFile = format.generate "hydra.yaml" cfg.settings;
  useMysql = cfg.database.type == "mysql";
  usePostgresql = cfg.database.type == "postgres";
in
{
  options.services.ory-hydra = with lib; {
    enable = mkEnableOption "ORY hydra service";
    package = mkOption {
      default = pkgs.ory-hydra;
      type = types.package;
      defaultText = literalExpression "pkgs.ory-hydra";
      description = "ORY hydra derivation to use.";
    };
    environmentFiles = mkOption {
      type = types.listOf types.path;
      default = [ ];
      description = ''
        List of environment files set in the ORY hydra systemd service.
        For example passwords should be set in one of these files.
      '';
    };
    setupNginx = mkOption {
      type = types.bool;
      default = config.services.nginx.enable;
      defaultText = literalExpression "config.services.nginx.enable";
      description = ''
        Whether to setup NGINX.
        Further nginx configuration can be done by changing
        <option>services.nginx.virtualHosts.&lt;frontendHostname&gt;</option>.
        This enables TLS and ACME by default.
      '';
    };
    publicBaseHost = mkOption {
      type = types.str;
      description = "The base URL for the public ORY hydra endpoint.";
    };
    settings = mkOption {
      type = format.type;
      default = { };
      description = ''
        ORY Hydra configuration. Refer to
        <link xlink:href="https://www.ory.sh/hydra/docs/reference/configuration"/>
        for details on supported values.
      '';
    };
  };
  config = lib.mkIf cfg.enable {
    services.ory-hydra.settings = {
      serve = {
        admin = {
          host = "unix:/run/ory-hydra/admin.sock";
          socket = {
            mode = 504; # 770 in octal (base 8), 504 in decimal (base 10)
          };
        };
        public = {
          host = "unix:/run/ory-hydra/public.sock";
          socket = {
            mode = 511;
          };
        };
      };
      urls.self = {
        public = "https://${cfg.publicBaseHost}";
        issuer = "https://${cfg.publicBaseHost}";
      };
    };

    systemd.services.ory-hydra = {
      description = "ory-hydra";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      preStart = ''
        versionFile="/var/lib/ory-hydra/src-version"
        # Auto-migrate on first run or if the package has changed
        if [[ $(cat "$versionFile" 2>/dev/null) != ${cfg.package} ]]; then
          ${cfg.package}/bin/hydra migrate sql -y -e -c ${configFile}
          echo ${cfg.package} > "$versionFile"
        fi
      '';

      serviceConfig = {
        Type = "simple";
        DynamicUser = true;
        User = "ory-hydra";
        Group = "ory-hydra";
        StateDirectory = "ory-hydra";
        RuntimeDirectory = "ory-hydra";
        ExecStart = "${cfg.package}/bin/hydra serve all -c ${configFile}";
        Restart = "always";
        EnvironmentFile = cfg.environmentFiles;
      };
    };

    services.nginx.virtualHosts."${cfg.publicBaseHost}" = mkIf cfg.setupNginx {
      enableACME = true;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://unix:/run/ory-hydra/public.sock";
      };
    };
  };
}
