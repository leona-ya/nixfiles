{ config, pkgs, lib, inputs, ... }:

let
  commonHeaders = lib.concatStringsSep "\n" (lib.filter (line: lib.hasPrefix "add_header" line) (lib.splitString "\n" config.services.nginx.commonHttpConfig));
in {
  em0lar.secrets."e1mo_ask_smtp_password".owner = "nginx";
  services.nginx.virtualHosts = {
    "auth.em0lar.de" = {
      enableACME = true;
      forceSSL = true;
      serverAliases = [
        "auth.emolar.de"
        "auth.labcode.de"
      ];
      locations."/" = {
        extraConfig = "return 301 https://auth.em0lar.dev$request_uri;";
      };
    };
    "auth.em0lar.dev" = {
      enableACME = true;
      forceSSL = true;
      locations."/".proxyPass = "http://10.151.4.19:8080";
    };
    "element.em0lar.de" = {
      enableACME = true;
      forceSSL = true;
      root = pkgs.element-web.override {
        conf = {
          default_server_config."m.homeserver" = {
            "base_url" = "https://matrix.labcode.de";
            "server_name" = "labcode.de";
          };
        };
      };
    };
    "em0lar.de" = let
      client = { "m.homeserver" = { base_url = "https://matrix.labcode.de"; }; };
      server = { "m.server" = "matrix.labcode.de:443"; };
    in {
      enableACME = true;
      forceSSL = true;
      serverAliases = [
        "www.em0lar.de"
        "emolar.de"
        "www.emolar.de"
        "labcode.de"
        "www.labcode.de"
        "leomaroni.de"
        "www.leomaroni.de"
        "www.em0lar.dev"
      ];
      locations = {
        "/" = {
          extraConfig = "return 301 https://em0lar.dev$request_uri;";
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
    "em0lar.dev" = {
      enableACME = true;
      forceSSL = true;
      root = pkgs.em0lar-dev-website;
    };
    "static.labcode.de" = {
      enableACME = true;
      forceSSL = true;
      serverAliases = [
        "cdn.labcode.de"
      ];
      root = fetchGit {
        url = "https://git.em0lar.de/em0lar/static.labcode.de";
        rev = "f53ae4405b5e160838c4a3097df789dd612740c9";
      };
      locations."/" = {
        extraConfig = ''
          autoindex on;
        '';
      };
    };
    "webmail.em0lar.dev" = {
      enableACME = true;
      forceSSL = true;
      root = pkgs.rainloop-community;
      locations."/" = {
        index = "index.php";
        tryFiles = "$uri $uri/ $uri/index.php index.php";
      };
      locations."~ \\.php$ " = {
        extraConfig = ''
          fastcgi_index index.php;
          fastcgi_pass unix:${config.services.phpfpm.pools."nginx-default".socket};
          include ${pkgs.nginx}/conf/fastcgi_params;
          include ${pkgs.nginx}/conf/fastcgi.conf;
        '';
       };
    };
    "wifi.em0lar.dev" = {
      enableACME = true;
      forceSSL = true;
      serverAliases = [
        "wifi.em0lar.de"
        "wifi.labcode.de"
      ];
      locations."/".proxyPass = "http://10.151.4.19:40000";
    };
    "tell.em0lar.de" = {
      enableACME = true;
      forceSSL = true;
      root = pkgs."e1mo-ask".override {
        config = ''
          <?php
          return [
            "owner" => [
              "name" => "em0lar",
              "e-mail" => "tell@em0lar.de",
              "recipient-choices" => [
                  "enabled" => true,
                  "choices" => [
                      "em0lar.de" => [ "tell", "tolles", "liebenswertes", "nerviges", "kaputtmachendes", "stoerendes" ]
                  ]
              ],
              "allow-bad-recipient" => false, // Set to tue if you want to skip PHPMailers E-Mail validation (e.g. name only recipients for local test sendmail setup)
            ],
            "message" => [
              "subject" => "[tell.em0lar.de] Someone wanted to tell you something",
              "sender" => "no-reply@labcode.de",
              "force-sender" => true, // Always set it to sender even if a senders E-Mail is given
            ],
            "email" => [
              "provider" => "smtp",
              "smtp" => [
                "host" => "mail.labcode.de",
                "port" => 465,
                "crypt" => "smtps",
                "user" => "no-reply@labcode.de",
                "pass" => trim(file_get_contents('${config.em0lar.secrets."e1mo_ask_smtp_password".path}'))
              ],
            ],
          ];
        '';
      };
      locations."/" = {
        index = "index.php";
        tryFiles = "$uri $uri/ $uri/index.php index.php";
      };
      locations."~ \\.php$ " = {
        extraConfig = ''
          fastcgi_index index.php;
          fastcgi_pass unix:${config.services.phpfpm.pools."nginx-default".socket};
          include ${pkgs.nginx}/conf/fastcgi_params;
          include ${pkgs.nginx}/conf/fastcgi.conf;
        '';
       };
    };
    "paulreisenberg.de" = { # for pr
      enableACME = true;
      forceSSL = true;
      serverAliases = [
        "www.paulreisenberg.de"
      ];
      locations."/".proxyPass = "http://10.151.4.14:80";
    };
    "kopftausch.paulchenpanther.de" = { # for pr
      enableACME = true;
      forceSSL = true;
      locations."/".proxyPass = "http://10.151.4.14:8000";
    };
    "opendatamap.net" = {
      enableACME = true;
      forceSSL = true;
      serverAliases = [
        "www.opendatamap.net"
      ];
      root = pkgs.opendatamap-net;
    };
    "grafana.opendatamap.net" = {
      enableACME = true;
      forceSSL = true;
      locations."/".proxyPass = "http://51.15.21.208:3000";
    };
    "node-red.opendatamap.net" = {
      enableACME = true;
      forceSSL = true;
      locations."/".proxyPass = "http://51.15.21.208:1880";
    };
    "rhein-sieg.opendatamap.net" = {
      enableACME = true;
      forceSSL = true;
      locations."/".proxyPass = "http://51.15.21.208:3005";
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
