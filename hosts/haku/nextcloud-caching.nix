{ lib, pkgs, config, ... }:
{
  services.nginx = {
    virtualHosts."shared.cloud.leomaroni.de" = {
      root = "/var/lib/nextcloud-shared/public";
      locations."/" = {
        index = "index.php index.html /_h5ai/public/index.php";
      };
      locations."~ \\.php$ " = {
        extraConfig = ''
          fastcgi_index index.php;
          fastcgi_pass unix:${config.services.phpfpm.pools."nginx-default".socket};
          include ${pkgs.nginx}/conf/fastcgi_params;
          include ${pkgs.nginx}/conf/fastcgi.conf;
        '';
       };
      forceSSL = true;
      enableACME = true;
    };
  };
  users.users.cloudsharedsync = {
    isNormalUser = true;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO6Lotz6D/qHxbnp//zyZVioslXq98+DZx/LpA5VgTFW cloudsharedsync"
    ];
    shell = pkgs.zsh;
    hashedPassword = "!";
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
    phpEnv."PATH" = lib.makeBinPath [ pkgs.php pkgs.zip ];
  };
}
