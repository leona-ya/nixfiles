
{ config, lib, pkgs, ... }:

let
  keycloakTheme = pkgs.stdenv.mkDerivation {
    name = "leona-keycloak-theme";
    src = ../../keycloak/theme;
    dontBuild = true;
    installPhase = ''
      mkdir -p $out
      cp -r * $out
    '';
  };
in
{
  l.sops.secrets."services/stag-keycloak/database_password" = {
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
#      #extraFeatures = [ "persistent-user-sessions" ];
      #disabledFeatures = [ "kerberos" ];
    #};
    database.passwordFile = config.sops.secrets."services/stag-keycloak/database_password".path;
    themes = {
      leona = keycloakTheme;
    };
    plugins = [
      pkgs.keycloak.plugins.keycloak-restrict-client-auth
    ];
    settings = {
      http-host = "127.0.0.1";
      http-port = 8080;
      hostname = "auth.stag.infspace.xyz";
      http-enabled = true;
      proxy-headers = "xforwarded";
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
  services.nginx.virtualHosts."auth.stag.infspace.xyz" = {
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
      return = "301 https://auth.stag.infspace.xyz/realms/leona/account/";
    };
  };
}
