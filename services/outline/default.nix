{ config, ... }:
let
  fqdn = "kb.leona.is";
in
{
  l.sops.secrets."services/outline/oidc_client_secret".owner = "outline";

  services.outline = {
    enable = true;
    cdnUrl = "https://${fqdn}";
    publicUrl = "https://${fqdn}";
    port = 3001;
    storage = {
      storageType = "local";
      localRootDir = "/persist/var/lib/outline";
    };
    oidcAuthentication = {
      displayName = "leona's SSO";
      clientId = "outline";
      tokenUrl = "https://auth.leona.is/realms/leona/protocol/openid-connect/token";
      authUrl = "https://auth.leona.is/realms/leona/protocol/openid-connect/auth";
      userinfoUrl = "https://auth.leona.is/realms/leona/protocol/openid-connect/userinfo";
      clientSecretFile = config.sops.secrets."services/outline/oidc_client_secret".path;
    };
  };

  services.nginx.virtualHosts."${fqdn}" = {
    forceSSL = true;
    enableACME = true;
    kTLS = true;
    locations = {
      "/" = {
        proxyPass = "http://localhost:${toString config.services.outline.port}/";
        proxyWebsockets = true;
      };
    };
  };
}
