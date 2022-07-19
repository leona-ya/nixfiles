{ config, pkgs, lib, ... }:

{
  l.sops.secrets."services/vikunja/env" = {};

  services.vikunja = {
    enable = true;
    environmentFiles = [ config.sops.secrets."services/vikunja/env".path ];
    frontendScheme = "https";
    frontendHostname = "todo.leona.is";
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
        host = "mail.leona.is";
        port = 465;
        forcessl = true;
        username = "no-reply@leona.is";
        fromemail = "no-reply@leona.is";
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
            authurl = "https://hydra.sso.leona.is/";
            clientid = "vikunja";
            clientsecret = "4d0fb45b-f508-446b-a1ac-ecee41f90511";
          }];
        };
      };
    };
  };
  services.nginx.virtualHosts."${config.services.vikunja.frontendHostname}" = {
    enableACME = true;
    forceSSL = true;
    kTLS = true;
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
