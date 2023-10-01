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

  pluginRestrictClientAuth  = pkgs.stdenv.mkDerivation rec {
    pname = "keycloak-restrict-client-auth";
    version = "22.0.0";

    src = pkgs.fetchurl {
      url = "https://github.com/sventorben/keycloak-restrict-client-auth/releases/download/v${version}/keycloak-restrict-client-auth.jar";
      sha256 = "sha256-G4XMZ2CJcu3AtKtARAnSICawQvsBPi6H138f7DH9eRQ=";
    };

    dontUnpack = true;
    dontBuild = true;

    installPhase = ''
      mkdir -p $out
      install "$src" "$out"
    '';
  };
in {
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
    package = pkgs.keycloak.override {
      extraFeatures = [ "declarative-user-profile" ];
      disabledFeatures = [ "kerberos" ];
    };
    database.passwordFile = config.sops.secrets."services/keycloak/database_password".path;
    initialAdminPassword = "foobar";
    themes = {
      leona = keycloakTheme;
    };
    plugins = [
      pluginRestrictClientAuth
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
