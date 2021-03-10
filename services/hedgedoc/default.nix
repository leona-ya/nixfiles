{ config, ... }:

{
  em0lar.secrets = {
    "hedgedoc/saml_idpcert.pem".owner = "hedgedoc";
  };
  services.hedgedoc = {
    enable = true;
    configuration = {
      path = "/run/hedgedoc/hedgedoc.sock";
      domain = "md.em0lar.dev";
      protocolUseSSL = true;
      allowFreeURL = true;
      email = false;
      allowEmailRegister = false;
      allowAnonymous = false;
      db = {
        dialect = "postgres";
        host = "/run/postgresql";
      };
      saml = {
        issuer = "hedgedoc";
        identifierFormat = "urn:oasis:names:tc:SAML:1.1:nameid-format:unspecified";
        idpSsoUrl = "https://auth.em0lar.dev/auth/realms/em0lar/protocol/saml";
        idpCert = config.em0lar.secrets."hedgedoc/saml_idpcert.pem".path;
        attribute = {
          email = "email";
          username = "username";
        };
      };
    };
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
      locations."/".proxyPass = "http://unix:/run/hedgedoc/hedgedoc.sock";
    };
  };
}
