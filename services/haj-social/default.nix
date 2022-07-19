{ lib, config, pkgs, ... }:

{
  l.sops.secrets."services/pleroma/secret_config".owner = "pleroma";
  services.pleroma = {
    enable = true;
    configs = [ (lib.fileContents ./config.exs) ];
    secretConfigFile = config.sops.secrets."services/pleroma/secret_config".path;
    package = (pkgs.pleroma.override {
      cookieFile = "/var/lib/pleroma/.cookie";
    }).overrideAttrs (old: {
      patches = [
        ./manifest.diff
        ./reply-visibility.diff
      ];
      postInstall = let
        custom-styles = {
          haj-social = "/static/themes/haj-social.json";
        };
        custom-styles-json = pkgs.writeText "custom-styles.json" (builtins.toJSON custom-styles);
        custom-static = pkgs.stdenv.mkDerivation {
          name = "pleroma-custom-static";
          src = builtins.fetchGit {
            url = "https://github.com/haj-social/static.git";
            ref = "main";
            rev = "92e80d58bc6e95509066d32ce25dfcce7b4106da";
          };

          installPhase = ''
            mkdir -p $out/
            cp -r * $out/
          '';
        };
      in ''
        rm -rf $out/lib/pleroma-${config.services.pleroma.package.version}/priv/static/static
        ${pkgs.rsync}/bin/rsync -a ${pkgs.pleroma-fe}/ $out/lib/pleroma-${config.services.pleroma.package.version}/priv/static/
        ${pkgs.rsync}/bin/rsync -a ${custom-static}/ $out/lib/pleroma-${config.services.pleroma.package.version}/priv/static/static/
        chmod u+w -R $out/lib/pleroma-${config.services.pleroma.package.version}/priv/static/
        mv $out/lib/pleroma-${config.services.pleroma.package.version}/priv/static/static/styles.json old-styles.json
        ${pkgs.jq}/bin/jq -s add ${custom-styles-json} old-styles.json > $out/lib/pleroma-${config.services.pleroma.package.version}/priv/static/static/styles.json
      '';
    });
  };
  systemd.services.pleroma = {
    serviceConfig.RuntimeDirectory = "pleroma";
    environment = {
      DOMAIN = "social.haj.gf";
    };
  };

  services.nginx.virtualHosts."social.haj.gf" = {
    enableACME = true;
    forceSSL = true;
    kTLS = true;
    locations = {
      "/" = {
        proxyPass = "http://localhost:4001";
        proxyWebsockets = true;
      };
      "= /favicon.png".tryFiles = "$uri /static/favicon.png";
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
