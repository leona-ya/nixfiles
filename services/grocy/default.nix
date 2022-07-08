{ config, lib, ... }:
let
  commonHeaders = lib.concatStringsSep "\n" (lib.filter (line: lib.hasPrefix "add_header" line) (lib.splitString "\n" config.services.nginx.commonHttpConfig));
in {
  l.sops.secrets = {
    "services/grocy/vouch_proxy_env".owner = "root";
  };
  o.services.grocy = {
    enable = true;
    hostName = "grocy.leona.is";
    settings = {
     AUTH_CLASS = "Grocy\\Middleware\\ReverseProxyAuthMiddleware";
     REVERSE_PROXY_AUTH_HEADER = "X_VOUCH_USERNAME";
     REVERSE_PROXY_AUTH_USE_ENV = true;
    };
  };
  services.nginx.virtualHosts."grocy.leona.is" = {
    locations."~ \\.php$".extraConfig = ''
      auth_request /_vouch/validate;
      auth_request_set $auth_resp_x_vouch_email $upstream_http_x_vouch_user;
      auth_request_set $auth_resp_x_vouch_username $upstream_http_x_vouch_idp_claims_preferred_username;
      fastcgi_param X_VOUCH_USERNAME $auth_resp_x_vouch_username;
    '';
    locations."~ \\.(js|css|ttf|woff2?|png|jpe?g|svg)$".extraConfig = ''
      auth_request /_vouch/validate;
      ${commonHeaders}
    '';
  };
#  services.nginx.virtualHosts."api.grocy.leona.is" = {
#    root = "${pkgs.grocy}/public";
#    locations."/".extraConfig = ''
#      rewrite ^ /index.php/api;
#    '';
#    locations."~ \.php$".extraConfig = ''
#      fastcgi_split_path_info ^(.+\.php)(/.+)$;
#      fastcgi_pass unix:${config.services.phpfpm.pools.grocy.socket};
#      include ${config.services.nginx.package}/conf/fastcgi.conf;
#      include ${config.services.nginx.package}/conf/fastcgi_params;
#    '';
#    enableACME = true;
#    forceSSL = true;
#  };

  services.vouch-proxy = {
    enable = true;
    servers."grocy.leona.is" = {
      clientId = "grocy";
      port = 12301;
      environmentFiles = [ config.sops.secrets."services/grocy/vouch_proxy_env".path ];
    };
  };

}
