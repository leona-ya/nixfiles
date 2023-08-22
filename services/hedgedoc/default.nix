{ config, ... }:

{
  l.sops.secrets = {
    "services/hedgedoc/env".owner = "hedgedoc";
  };
  services.hedgedoc = {
    enable = true;
    settings = {
      debug = false;
      path = "/run/hedgedoc/hedgedoc.sock";
      domain = "md.leona.is";
      protocolUseSSL = true;
      allowFreeURL = true;
      email = false;
      allowEmailRegister = false;
      allowAnonymous = false;
      allowAnonymousEdits = true;
      db = {
        dialect = "postgres";
        host = "/run/postgresql";
      };
      oauth2 = {
        tokenURL = "https://auth.leona.is/realms/leona/protocol/openid-connect/token";
        authorizationURL = "https://auth.leona.is/realms/leona/protocol/openid-connect/auth";
        userProfileURL = "https://auth.leona.is/realms/leona/protocol/openid-connect/userinfo";
        clientID = "hedgedoc";
        clientSecret = "";
      };
    };
    environmentFile = config.sops.secrets."services/hedgedoc/env".path;
  };

  systemd.services.hedgedoc = {
    serviceConfig = {
      UMask = "0007";
      RuntimeDirectory = "hedgedoc";
    };
  };

  services.postgresql = {
    enable = true;
    ensureDatabases = [ "hedgedoc" ];
    ensureUsers = [
      {
        name = "hedgedoc";
        ensurePermissions."DATABASE hedgedoc" = "ALL PRIVILEGES";
      }
    ];
  };

  users.users.nginx.extraGroups = [ "hedgedoc" ];
  services.nginx.virtualHosts = {
    "md.leona.is" = {
      enableACME = true;
      forceSSL = true;
      kTLS = true;
      locations."/" = {
        proxyPass = "http://unix:/run/hedgedoc/hedgedoc.sock";
        proxyWebsockets = true;
      };
    };
  };
}
