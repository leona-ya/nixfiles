{ config, pkgs, ... }: {
  l.sops.secrets."services/snipe-it/app-key".owner = "snipeit";
  l.sops.secrets."services/snipe-it/mail-password".owner = "snipeit";
  services.snipe-it = {
    enable = true;
    appKeyFile = config.sops.secrets."services/snipe-it/app-key".path;
    hostName = "assets.leona.is";
    mail = {
      driver = "smtp";
      host = "mail.leona.is";
      port = 587;
      user = "no-reply@leona.is";
      passwordFile = config.sops.secrets."services/snipe-it/mail-password".path;
      encryption = "tls";
      from.address = "no-reply@leona.is";
    };
    nginx = {
      enableACME = true;
      forceSSL = true;
      kTLS = true;
    };
    config.DB_SOCKET = "/var/run/mysqld/mysqld.sock";
  };
  services.mysql = {
    enable = true;
    package = pkgs.mariadb;
    ensureDatabases = [ "snipeit" ];
    ensureUsers = [
      {
        name = "snipeit";
        ensurePermissions = {
          "snipeit.*" = "ALL PRIVILEGES";
        };
      }
    ];
  };
  services.nginx.virtualHosts = {
    "a.leona.is" = {
      locations."/".extraConfig = ''
        return 301 https://assets.leona.is/hardware$request_uri;
      '';
      enableACME = true;
      forceSSL = true;
      kTLS = true;
    };
    "found.leona.is" = {      
      enableACME = true;
      forceSSL = true;
      kTLS = true;
      locations."/".extraConfig = ''
        return 302 https://assets.leona.is;
      '';
    };
  };
}
