{ config, lib, pkgs, ... }:

let
  keycloakTheme = pkgs.stdenv.mkDerivation {
    name = "leona-keycloak-theme";
    src = ./theme;
    dontBuild = true;
    installPhase = ''
      mkdir -p $out
      cp -r * $out
    '';
  };
in
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
  users.groups.keycloak = { };
  services.keycloak = {
    enable = true;
    package = pkgs.keycloak.override {
      extraFeatures = [ ];
      disabledFeatures = [ "kerberos" ];
    };
    database.passwordFile = config.sops.secrets."services/keycloak/database_password".path;
    initialAdminPassword = "foobar";
    themes = {
      leona = keycloakTheme;
    };
    plugins = [
      pkgs.keycloak.plugins.keycloak-restrict-client-auth
    ];
    settings = {
      http-host = "127.0.0.1";
      http-port = 8080;
      hostname = "auth.leona.is";
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
  services.postgresql.enable = true;
  services.nginx.virtualHosts."auth.leona.is" = {
    enableACME = true;
    forceSSL = true;
    kTLS = true;
    locations."/" = {
      proxyPass = "http://localhost:8080";
      extraConfig = ''
        proxy_buffer_size          128k;
        proxy_buffers              4 256k;
        proxy_busy_buffers_size    256k;
      '';
    };
    locations."= /" = {
      return = "301 https://auth.leona.is/realms/leona/account/";
    };
  };
}
