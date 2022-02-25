{ config, ... }:

{
  em0lar.sops.secrets = {
    "services/vaultwarden/env" = {
      owner = "vaultwarden";
      group = "vaultwarden";
    };
  };

  services.postgresql = {
    enable = true;
    ensureDatabases = [ "vaultwarden" ];
    ensureUsers = [
      { name = "vaultwarden";
        ensurePermissions."DATABASE vaultwarden" = "ALL PRIVILEGES";
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
      domain = "https://vaultwarden.em0lar.dev";
      rocketAddress = "::1";
      rocketPort = 8081;
      smtpHost = "mail.em0lar.dev";
      smtpPort = 465;
      smtpSsl = true;
      smtpExplicitTLS = true;
      smtpAuthMechanism = "Plain";
    };
  };

  services.nginx.virtualHosts = {
    "vaultwarden.em0lar.dev" = {
      enableACME = true;
      forceSSL = true;
      locations."/".proxyPass = "http://localhost:8081";
    };
  };
}
