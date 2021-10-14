{ config, pkgs, lib, ... }:

{
  em0lar.secrets."vikunja_environment_file" = {};

  services.vikunja = {
    enable = true;
    environmentFiles = [ config.em0lar.secrets."vikunja_environment_file".path ];
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
            name = "keycloak";
            authurl = "https://auth.em0lar.dev/auth/realms/em0lar";
            clientid = "vikunja";
            clientsecret = "b322f24b-b57f-41d0-b0bc-96b00a5ed329";
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
