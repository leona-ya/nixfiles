{ config, lib, ... }:

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
    httpPort = "8080";
    frontendUrl = "";
    databasePasswordFile = config.em0lar.secrets."keycloak_database_password".path;
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
