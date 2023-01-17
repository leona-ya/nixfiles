{ config, lib, ... }:

with lib;

let
  cfg = config.l.nginx-sni-proxy;
in {
  options.l.nginx-sni-proxy = {
    enable = mkEnableOption "NGINX SNI Proxy";
    upstreamHosts = mkOption {
      type = with types; attrsOf (listOf str);
      default = {};
    };
  };
  config = mkIf cfg.enable {
    services.nginx = let
      upstreams = (concatStringsSep "\n" (mapAttrsToList (host: dest:
        "${host} ${dest}:443;"
      ) (concatMapAttrs (dest: hosts: 
          (genAttrs hosts (host: dest))
        ) cfg.upstreamHosts
        
      )));
    in {
      defaultListenAddresses = [ "[::0]" ];
      streamConfig = ''
        map $ssl_preread_server_name $sni_upstream {
          ${upstreams}
          default [::1]:443;
        }
        server {
          listen 0.0.0.0:443;
          ssl_preread on;
          resolver 1.1.1.1;
          proxy_pass $sni_upstream;
        }
      '';
      appendHttpConfig = ''
        server {
          listen        0.0.0.0:80;
          server_name   _;
          return 301 https://$host$request_uri;
        }
      '';
    };
  };
}