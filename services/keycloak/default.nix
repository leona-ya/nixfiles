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
    package = (pkgs.keycloak.override {
      jre = pkgs.openjdk11;
    });
    httpPort = "8080";
    frontendUrl = "https://auth.em0lar.dev/auth";
    database.passwordFile = config.sops.secrets."services/keycloak/database_password".path;
    extraConfig = {
      "subsystem=undertow" = {
        "server=default-server" = {
          "http-listener=default" = {
            "proxy-address-forwarding" = true;
          };
        };
      };
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
