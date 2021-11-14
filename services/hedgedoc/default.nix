{ config, ... }:

{
  em0lar.sops.secrets = {
    "services/hedgedoc/env".owner = "hedgedoc";
  };
  services.hedgedoc = {
    enable = true;
    configuration = {
      debug = true;
      path = "/run/hedgedoc/hedgedoc.sock";
      domain = "md.em0lar.dev";
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
        tokenURL = "https://auth.em0lar.dev/auth/realms/em0lar/protocol/openid-connect/token";
        authorizationURL = "https://auth.em0lar.dev/auth/realms/em0lar/protocol/openid-connect/auth";
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
    "md.em0lar.de" = {
      enableACME = true;
      forceSSL = true;
      serverAliases = [
        "md.emolar.de"
        "md.labcode.de"
      ];
      locations."/" = {
        extraConfig = "return 301 https://md.em0lar.dev$request_uri;";
      };
    };
    "md.em0lar.dev" = {
      enableACME = true;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://unix:/run/hedgedoc/hedgedoc.sock";
        proxyWebsockets = true;
      };
    };
  };
}
