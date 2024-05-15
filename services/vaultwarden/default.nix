{ config, ... }:

{
  l.sops.secrets = {
    "services/vaultwarden/env" = {
      owner = "vaultwarden";
      group = "vaultwarden";
    };
  };

  services.postgresql = {
    enable = true;
    ensureDatabases = [ "vaultwarden" ];
    ensureUsers = [
      {
        name = "vaultwarden";
        ensureDBOwnership = true;
      }
    ];
  };

  services.vaultwarden = {
    enable = true;
    dbBackend = "postgresql";
    environmentFile = config.sops.secrets."services/vaultwarden/env".path;
    config = {
      databaseUrl = "postgres://vaultwarden@/vaultwarden?host=/run/postgresql";
      ipHeader = "X-Real-IP";
      emergencyAccessAllowed = false;
      signupsAllowed = false;
      domain = "https://pass.leona.is";
      rocketAddress = "::1";
      rocketPort = 8081;
      smtpHost = "mail.leona.is";
      smtpPort = 465;
      smtpSsl = true;
      smtpExplicitTLS = true;
      smtpAuthMechanism = "Plain";
    };
  };

  services.nginx.virtualHosts = {
    "pass.leona.is" = {
      enableACME = true;
      forceSSL = true;
      kTLS = true;
      locations."/" = {
        proxyPass = "http://localhost:8081";
        proxyWebsockets = true;
      };
    };
  };
}

