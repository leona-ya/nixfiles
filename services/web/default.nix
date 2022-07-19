{ config, pkgs, lib, inputs, ... }:

let
  commonHeaders = lib.concatStringsSep "\n" (lib.filter (line: lib.hasPrefix "add_header" line) (lib.splitString "\n" config.services.nginx.commonHttpConfig));
in {
  l.sops.secrets."all/mail/no_reply_password".owner = "nginx";
  services.nginx.virtualHosts = {
    "element.em0lar.de" = {
      enableACME = true;
      forceSSL = true;
      kTLS = true;
      root = pkgs.element-web.override {
        conf = {
          default_server_config."m.homeserver" = {
            "base_url" = "https://matrix.labcode.de";
            "server_name" = "labcode.de";
          };
        };
      };
    };
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
      };
    };
    "static.labcode.de" = {
      enableACME = true;
      forceSSL = true;
      kTLS = true;
      serverAliases = [
        "cdn.labcode.de"
      ];
      root = fetchGit {
        url = "https://git.em0lar.de/em0lar/static.labcode.de";
        rev = "f53ae4405b5e160838c4a3097df789dd612740c9";
      };
      locations."/" = {
        extraConfig = ''
          ${commonHeaders}
          autoindex on;
          add_header Access-Control-Allow-Origin '*';
        '';
      };
    };
    "opendatamap.net" = {
      enableACME = true;
      forceSSL = true;
      kTLS = true;
      serverAliases = [
        "www.opendatamap.net"
      ];
      root = pkgs.opendatamap-net;
    };
    "gat.leomaroni.de" = {
      enableACME = true;
      forceSSL = true;
      kTLS = true;
      root = "/var/www/gat.leomaroni.de";
      extraConfig = ''
        client_max_body_size 100M;
      '';
      locations."/" = {
        index = "index.php";
        tryFiles = "$uri $uri/ /index.php?$args";
      };
      locations."~ \\.php$ " = {
        extraConfig = ''
          fastcgi_index index.php;
          fastcgi_pass unix:${config.services.phpfpm.pools."nginx-gat".socket};
          include ${pkgs.nginx}/conf/fastcgi_params;
          include ${pkgs.nginx}/conf/fastcgi.conf;
        '';
       };
    };
    "gatabi22.de" = {
      forceSSL = true;
      enableACME = true;
      kTLS = true;
      locations = {
        "/".proxyPass = "http://10.151.21.42:8345";
        "= /".return = "302 https://gatabi22.de/Abi2022";
        "/static/".proxyPass = "http://10.151.21.42:80";
        "/media/".proxyPass = "http://10.151.21.42:80";
      };
    };
    "kopftausch.paulchenpanther.de" = {
      forceSSL = true;
      enableACME = true;
      kTLS = true;
      locations = {
        "/" = {
          proxyPass = "http://10.151.21.40:8000";
        };
      };
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
  services.phpfpm.pools."nginx-gat" = {
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
    phpOptions = ''
      upload_max_filesize = "100M";
      post_max_size = "100M";
      memory_limit = "100M";
      display_errors = On;
    '';
    phpEnv."PATH" = lib.makeBinPath [ pkgs.php ];
  };


  # --------------------------
  services.mysql = {
    enable = true;
    package = pkgs.mariadb;
    ensureDatabases = [ "gat" ];
    ensureUsers = [
      {
        name = "gat";
        ensurePermissions = {
          "gat.*" = "ALL PRIVILEGES";
        };
      }
    ];
  };
}
