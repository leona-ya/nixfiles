{ lib, config, pkgs, ... }:

{
  l.sops.secrets."services/pleroma/secret_config".owner = "pleroma";
  services.pleroma = {
    enable = true;
    configs = [ (lib.fileContents ./config.exs) ];
    secretConfigFile = config.sops.secrets."services/pleroma/secret_config".path;
  };
  systemd.services.pleroma = {
    serviceConfig.RuntimeDirectory = "pleroma";
    environment = {
      DOMAIN = "haj-social.leona.is";
    };
  };

  services.nginx.virtualHosts."haj-social.leona.is" = {
    enableACME = true;
    forceSSL = true;
    locations = {
      "/" = {
        proxyPass = "http://localhost:4001";
        proxyWebsockets = true;
      };
      "= /favicon.png".tryFiles = "$uri /static/favicon.png";
      "/static/".root = let
        pleroma-static = "${config.services.pleroma.package}/lib/pleroma-${config.services.pleroma.package.version}/priv/static/static/";

        custom-static = pkgs.stdenv.mkDerivation {
          name = "pleroma-custom-static";
          src = builtins.fetchGit {
            url = "https://github.com/haj-social/static.git";
            ref = "main";
            rev = "38235c2633dc1b6462853400bdcb842c18349dc3";
          };

          installPhase = ''
            mkdir -p $out/
            cp -r * $out/
          '';
          meta.priority = -5;
        };
        custom-styles-json = pkgs.writeText "custom-styles.json" (builtins.toJSON {
          haj-social = "/static/themes/haj-social.json";
        });
        custom-styles-static = pkgs.runCommand "pleroma-custom-static" { } ''
          mkdir -p $out
          ${pkgs.jq}/bin/jq -s add ${custom-styles-json} ${pleroma-static}/styles.json > $out/styles.json
        '';

        merged-static = pkgs.buildEnv {
          name = "pleroma-merged-static";
          paths = [
            pleroma-static
            custom-static
            (lib.hiPrio custom-styles-static)
          ];
          extraPrefix = "/static";
        };
      in merged-static;
    };
  };

  services.postgresql = {
    enable = true;
    ensureDatabases = [ "pleroma" ];
    ensureUsers = [
      {
        name = "pleroma";
        ensurePermissions."DATABASE pleroma" = "ALL PRIVILEGES";
      }
    ];
  };
}
