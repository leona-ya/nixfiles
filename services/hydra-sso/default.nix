{ config, pkgs, lib, ... }:

let
  legitimaBaseURL = "https://sso.leona.is";
in {
  l.sops.secrets."services/hydra-sso/hydra-env" = {};

  environment.systemPackages = [ pkgs.ory-hydra ];

  services.ory-hydra = {
    enable = true;
    environmentFiles = [ config.sops.secrets."services/hydra-sso/hydra-env".path ];
    publicBaseHost = "hydra.sso.leona.is";
    settings = {
      dsn = "postgres://ory-hydra@/ory-hydra?host=/run/postgresql";
      urls = {
        login = "${legitimaBaseURL}/oidc/login";
        consent = "${legitimaBaseURL}/oidc/consent";
      };
      serve.admin = {
        host = lib.mkForce "localhost";
        tls = {
          enabled = false;
        };
      };
      # TODO: webfinger.oidc_discovery
    };
  };

  services.postgresql = {
    ensureDatabases = [ "ory-hydra" "legitima" ];
    ensureUsers = [
      { name = "ory-hydra";
        ensurePermissions = { "DATABASE \"ory-hydra\"" = "ALL PRIVILEGES"; };
      }
      { name = "legitima";
        ensurePermissions = { "DATABASE \"ory-hydra\"" = "ALL PRIVILEGES"; };
      }
    ];
  };

  # -----------------------------
  # legitima
  l.sops.secrets."services/hydra-sso/legitima_config" = {
    owner = "legitima";
  };

  systemd.services.legitima = {
    description = "legitima";
    after = [ "network.target" "ory-hydra.service" ];
    wantedBy = [ "multi-user.target" ];
    restartTriggers = [ config.sops.secrets."services/hydra-sso/legitima_config".path ];

    environment = {
      ROCKET_CONFIG = "/var/lib/legitima/Rocket.toml";
    };

    preStart = ''
      cp -f ${config.sops.secrets."services/hydra-sso/legitima_config".path} /var/lib/legitima/Rocket.toml
    '';

    serviceConfig = {
      Type = "simple";
      DynamicUser = false;
      User = "legitima";
      Group = "legitima";
      SupplementaryGroups = "ory-hydra ${config.services.redis.servers.legitima.user}";
      StateDirectory = "legitima";
      ExecStart = "${pkgs.legitima}/bin/legitima";
      Restart = "always";
    };
  };

  users.users.legitima = {
    description = "Vikunja Service";
    createHome = false;
    group = "legitima";
    isSystemUser = true;
  };

  users.groups.legitima = {};

  services.redis.servers.legitima.enable = true;

  services.nginx.virtualHosts."hydra.sso.leona.is".kTLS = true;
  services.nginx.virtualHosts."sso.leona.is" = {
    enableACME = true;
    forceSSL = true;
    kTLS = true;
    locations."/" = {
      proxyPass = "http://[::1]:8000";
    };
  };
}
