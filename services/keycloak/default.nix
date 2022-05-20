{ config, lib, pkgs, ... }:

{
  l.sops.secrets."services/keycloak/database_password" = {
    owner = "keycloak";
    group = "postgres";
    mode = "0440";
  };
  users.users.keycloak = {
    description = "Keycloak Service";
    useDefaultShell = true;
    group = "keycloak";
    isSystemUser = true;
  };
  users.groups.keycloak = {};
  services.keycloak = {
    enable = true;
    database.passwordFile = config.sops.secrets."services/keycloak/database_password".path;
    initialAdminPassword = "";
    settings = {
      http-host = "127.0.0.1";
      http-port = 8080;
      http-relative-path = "/auth";
      hostname = "auth.em0lar.dev";
      proxy = "edge";
    };
  };
  systemd.services.keycloak = {
    serviceConfig = {
      DynamicUser = lib.mkForce false;
      User = "keycloak";
      Group = "keycloak";
    };
  };
  services.nginx.virtualHosts = {
    "auth.em0lar.de" = {
      enableACME = true;
      forceSSL = true;
      serverAliases = [
        "auth.labcode.de"
      ];
      locations."/" = {
        extraConfig = "return 301 https://auth.em0lar.dev$request_uri;";
      };
    };
    "auth.em0lar.dev" = {
      enableACME = true;
      forceSSL = true;
      locations."/".proxyPass = "http://localhost:8080";
    };
  };
}
