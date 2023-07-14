{ config, lib, ... }:

with lib;

let
  cfg = config.l.nginx;
in {
  options.l.nginx = {
    virtualHosts = mkOption {
      default = {};
      type = types.attrsOf(types.submodule {
        options = {
          lokiAccessLog = mkOption {
            type = types.submodule {
              options = {
                enable = mkEnableOption "Loki access log in nginx vhost";
              };
            };
          };
        };
      });
    };
  };

  config = mkIf (cfg.virtualHosts != {}) {
    services.logrotate.settings."nginx" = {
      frequency = "daily";
      rotate = 7;
      create = true;
      maxsize = "512M";
    };
    services.nginx = {
      commonHttpConfig = ''
        log_format loki_access_log_full escape=json '{'
          '"ms": "$msec", ' # request unixtime in seconds with a milliseconds resolution
          '"uri": "$uri", ' # full path no arguments if the request
          '"status": "$status", ' # response status code
          '"referer": "$http_referer", ' # HTTP referer
          '"vhost": "$server_name", ' # the name of the vhost serving the request
          '"ssl_prot": "$ssl_protocol", ' # TLS protocol
          '"ssl_cipher": "$ssl_cipher", ' # TLS cipher
          '"method": "$request_method", ' # request method
          '"protocol": "$server_protocol" ' # request protocol, like HTTP/1.1 or HTTP/2.0
        '}';
      '';
      virtualHosts = (mapAttrs (name: value: {
        extraConfig = lib.mkIf value.lokiAccessLog.enable ''
          access_log /var/log/nginx/loki_access.log.gz loki_access_log_full gzip flush=5m;
        '';
      }) cfg.virtualHosts);
    };
  };  
}
