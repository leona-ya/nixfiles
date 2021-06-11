{ config, pkgs, ... }:

{
  em0lar.secrets."vikunja_environment_file" = {};

  services.vikunja = {
    enable = true;
    environmentFiles = [ config.em0lar.secrets."vikunja_environment_file".path ];
    package-api = (pkgs.vikunja-api.overrideAttrs (old: let
      version = "9147e6739fb228b7b5f689322e948c6619d16b08";
      src = pkgs.fetchgit {
        url = "https://kolaente.dev/vikunja/api.git";
        rev = version;
        sha256 = "sha256-yTaywYKzTFjIweaAXoSpHkUJ+HvDjRwNS3ZnVmpXvKU=";
      };
    in rec {
      name = "vikunja-api-${version}";
      inherit src;
      go-modules = (pkgs.buildGoModule {
        inherit name src;
        vendorSha256 = "sha256-RPxoQAobEIXs5EWHwawBZhoOP15ekn5OcrXYJgQL8Iw=";
        deleteVendor = true;
        runVend = true;
      }).go-modules;
    }));
    frontendScheme = "https";
    frontendHostname = "todo.em0lar.dev";
    extraConfig = {
      log.http = "off";
      auth = {
        local = {
          enabled = false;
        };
        openid = {
          enabled = true;
          providers = [{
            name = "keycloak";
            authurl = "https://auth.em0lar.dev/auth/realms/em0lar";
            clientid = "vikunja";
          }];
        };
      };
    };
    config = {
      service = {
        timezone = "Europe/Berlin";
      };
      database = {
        type = "postgres";
        host = "/run/postgresql";
      };
      mailer = {
        enabled = true;
        host = "mail.em0lar.dev";
        port = 465;
        forcessl = true;
        username = "no-reply@em0lar.dev";
        fromemail = "no-reply@em0lar.dev";
      };
    };
  };
  services.nginx.virtualHosts."${config.services.vikunja.frontendHostname}" = {
    enableACME = true;
    forceSSL = true;
  };
}
