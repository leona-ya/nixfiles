{ config, pkgs, lib, inputs, ... }:

let
  commonHeaders = lib.concatStringsSep "\n" (lib.filter (line: lib.hasPrefix "add_header" line) (lib.splitString "\n" config.services.nginx.commonHttpConfig));
in {
  services.nginx.virtualHosts = {
    "www.leona.is" = let
      client = { "m.homeserver" = { base_url = "https://matrix.labcode.de"; }; };
      server = { "m.server" = "matrix.labcode.de:443"; };
    in {
      enableACME = true;
      forceSSL = true;
      kTLS = true;
      serverAliases = [
        "labcode.de"
      ];
      locations = {
        "/" = {
          extraConfig = "return 301 https://leona.is$request_uri;";
        };
        "= /.well-known/matrix/client" = {
          root = pkgs.writeTextDir ".well-known/matrix/client" "${builtins.toJSON client}";
          extraConfig = ''
            ${commonHeaders}
            add_header Access-Control-Allow-Origin *;
            add_header Access-Control-Allow-Methods 'GET, POST, PUT, DELETE, OPTIONS';
            add_header Access-Control-Allow-Headers 'Origin, X-Requested-With, Content-Type, Accept, Authorization';
          '';
        };
        "= /.well-known/matrix/server" = {
          root = pkgs.writeTextDir ".well-known/matrix/server" "${builtins.toJSON server}";
          extraConfig = ''
            ${commonHeaders}
            add_header Access-Control-Allow-Origin *;
            add_header Access-Control-Allow-Methods 'GET, POST, PUT, DELETE, OPTIONS';
            add_header Access-Control-Allow-Headers 'Origin, X-Requested-With, Content-Type, Accept, Authorization';
          '';
        };
      };
    };
    "leona.is" = let
       client = { "m.homeserver" = { base_url = "https://matrix.leona.is"; }; };
       server = { "m.server" = "matrix.leona.is:443"; };
     in {
      enableACME = true;
      forceSSL = true;
      kTLS = true;
      root = pkgs.leona-is-website;
      locations = {
        "= /.well-known/matrix/client" = {
          root = pkgs.writeTextDir ".well-known/matrix/client" "${builtins.toJSON client}";
          extraConfig = ''
            ${commonHeaders}
            add_header Access-Control-Allow-Origin *;
            add_header Access-Control-Allow-Methods 'GET, POST, PUT, DELETE, OPTIONS';
            add_header Access-Control-Allow-Headers 'Origin, X-Requested-With, Content-Type, Accept, Authorization';
          '';
        };
        "= /.well-known/matrix/server" = {
          root = pkgs.writeTextDir ".well-known/matrix/server" "${builtins.toJSON server}";
          extraConfig = ''
            ${commonHeaders}
            add_header Access-Control-Allow-Origin *;
            add_header Access-Control-Allow-Methods 'GET, POST, PUT, DELETE, OPTIONS';
            add_header Access-Control-Allow-Headers 'Origin, X-Requested-With, Content-Type, Accept, Authorization';
          '';
        };
        "= /cute" = {
          return = "200 'yes'";
          extraConfig = ''
            ${commonHeaders}
            add_header Content-Type text/html;
          '';
        };
      };
    };
#    "static.labcode.de" = {
#      enableACME = true;
#      forceSSL = true;
#      kTLS = true;
#      serverAliases = [
#        "cdn.labcode.de"
#      ];
#      root = fetchGit {
#        url = "https://git.em0lar.de/em0lar/static.labcode.de";
#        rev = "f53ae4405b5e160838c4a3097df789dd612740c9";
#      };
#      locations."/" = {
#        extraConfig = ''
#          ${commonHeaders}
#          autoindex on;
#          add_header Access-Control-Allow-Origin '*';
#        '';
#      };
#    };
    "opendatamap.net" = {
      enableACME = true;
      forceSSL = true;
      kTLS = true;
      serverAliases = [
        "www.opendatamap.net"
      ];
      root = pkgs.opendatamap-net;
    };
    "cv.leona.is" = {
      enableACME = true;
      forceSSL = true;
      kTLS = true;
      root = "/persist/var/www/cv.leona.is";
      locations."/".index = "index.pdf";
    };
  };
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
}
