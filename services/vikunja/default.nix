{ config, pkgs, lib, ... }:

{
  em0lar.sops.secrets."services/vikunja/env" = {};

  services.vikunja = {
    enable = true;
    environmentFiles = [ config.sops.secrets."services/vikunja/env".path ];
    frontendScheme = "https";
    frontendHostname = "todo.em0lar.dev";
    database = {
      type = "postgres";
      user = "vikunja";
      database = "vikunja";
      host = "/run/postgresql";
    };
    settings = {
      service.timezone = "Europe/Berlin";
      mailer = {
        enabled = true;
        host = "mail.em0lar.dev";
        port = 465;
        forcessl = true;
        username = "no-reply@em0lar.dev";
        fromemail = "no-reply@em0lar.dev";
      };
      log.http = "off";
      auth = {
        local = {
          enabled = false;
        };
        openid = {
          enabled = true;
          providers = [{
            name = "sso";
            authurl = "https://hydra.sso.em0lar.dev/";
            clientid = "vikunja";
          }];
        };
      };
    };
  };
  services.nginx.virtualHosts."${config.services.vikunja.frontendHostname}" = {
    enableACME = true;
    forceSSL = true;
  };

  services.postgresql = {
    ensureDatabases = [ "vikunja" ];
    ensureUsers = [
      { name = "vikunja";
        ensurePermissions = { "DATABASE vikunja" = "ALL PRIVILEGES"; };
      }
    ];
  };

  systemd.services.vikunja-api = {
    serviceConfig = {
      DynamicUser = lib.mkForce false;
      User = "vikunja";
      Group = "vikunja";
    };
  };

  users.users.vikunja = {
    description = "Vikunja Service";
    createHome = false;
    group = "vikunja";
    isSystemUser = true;
  };

  users.groups.vikunja = {};
}
