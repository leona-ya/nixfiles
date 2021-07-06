{ config, lib, pkgs, ... }:

{
  em0lar.secrets."keycloak_database_password" = {
    owner = "keycloak";
    group-name = "postgres";
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
    database.passwordFile = config.em0lar.secrets."keycloak_database_password".path;
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
  networking.firewall.allowedTCPPorts = [ 8080 ];
}
