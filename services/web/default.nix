{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:

let
  commonHeaders = lib.concatStringsSep "\n" (
    lib.filter (line: lib.hasPrefix "add_header" line) (
      lib.splitString "\n" config.services.nginx.commonHttpConfig
    )
  );
  vHosts = {
    "www.leona.is" = {
      locations = {
        "/" = {
          extraConfig = "return 301 https://leona.is$request_uri;";
        };
      };
    };
    "leona.is" =
      let
        client = {
          "m.homeserver" = {
            base_url = "https://matrix.leona.is";
          };
          "org.matrix.msc3575.proxy" = {
            "url" = "https://sliding-sync.matrix.leona.is";
          };
        };
        server = {
          "m.server" = "matrix.leona.is:443";
        };
      in
      {
        root = pkgs.leona-is-website;
        locations = {
          "= /.well-known/matrix/client" = {
            root = pkgs.writeTextDir ".well-known/matrix/client" "${builtins.toJSON client}";
            extraConfig = ''
              ${commonHeaders}
              add_header Access-Control-Allow-Origin *;
              add_header Access-Control-Allow-Methods 'GET, POST, PUT, DELETE, OPTIONS';
              add_header Access-Control-Allow-Headers 'Origin, X-Requested-With, Content-Type, Accept, Authorization';
              access_log off;
            '';
          };
          "= /.well-known/matrix/server" = {
            root = pkgs.writeTextDir ".well-known/matrix/server" "${builtins.toJSON server}";
            extraConfig = ''
              ${commonHeaders}
              add_header Access-Control-Allow-Origin *;
              add_header Access-Control-Allow-Methods 'GET, POST, PUT, DELETE, OPTIONS';
              add_header Access-Control-Allow-Headers 'Origin, X-Requested-With, Content-Type, Accept, Authorization';
              access_log off;
            '';
          };
          "= /cute" = {
            return = "200 'yes'";
            extraConfig = ''
              ${commonHeaders}
              add_header Content-Type text/html;
            '';
          };
          "= /health" = {
            return = "200 'ok'";
            extraConfig = ''
              ${commonHeaders}
              add_header Content-Type text/html;
              access_log off;
            '';
          };
        };
      };
    "cv.leona.is" = {
      root = "/var/www/cv.leona.is";
      locations."/".index = "index.pdf";
    };
    "openpgpkey.leona.is" = {
      locations."/.well-known/openpgpkey/leona.is/" = {
        alias = "${./wkd}/";
        extraConfig = ''
          ${commonHeaders}
          add_header Content-Type text/plain;
        '';
      };
    };
  };
in
{
  security.acme.certs."${config.networking.hostName}.${config.networking.domain}" = {
    group = "nginx";
    extraDomainNames = lib.flatten (
      lib.attrNames vHosts
      ++ lib.mapAttrsToList (_: c: if c ? serverAliases then c.serverAliases else [ ]) vHosts
    );
  };
  services.nginx.virtualHosts =
    vHosts
    |> builtins.mapAttrs (
      _: cfg:
      {
        forceSSL = true;
        kTLS = true;
        useACMEHost = "${config.networking.hostName}.${config.networking.domain}";
      }
      // cfg
    );

  services.phpfpm.pools."nginx-default" = {
    user = config.services.nginx.user;
    settings = {
      "pm" = "dynamic";
      "pm.max_children" = 32;
      "pm.max_requests" = 500;
      "pm.start_servers" = 2;
      "pm.min_spare_servers" = 2;
      "pm.max_spare_servers" = 5;
      "listen.owner" = config.services.nginx.user;
      "listen.group" = config.services.nginx.group;
    };
    phpEnv."PATH" = lib.makeBinPath [ pkgs.php ];
  };
  l.nginx.virtualHosts."leona.is".lokiAccessLog.enable = true;
  l.nginx.virtualHosts."cv.leona.is".lokiAccessLog.enable = true;
}
