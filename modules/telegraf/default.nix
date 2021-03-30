{ pkgs, lib, config, ... }:
let
  cfg = config.em0lar.telegraf;

in {
  options.em0lar.telegraf = with lib; {
    enable = mkEnableOption "em0lar telegraf";
    host = mkOption { type = types.str; };
    extraInputs = mkOption {
      type = types.attrs;
      default = {};
    };
  };
  config = lib.mkIf cfg.enable {
    services.telegraf = {
      enable = true;
      extraConfig = {
        agent.interval = "60s";
        inputs = {
          system = { };
          mem = { };
          cpu = { };
          disk = {
            ignore_fs = ["tmpfs" "devtmpfs" "devfs" "iso9660" "overlay" "aufs" "squashfs"];
          };
          systemd_units = { };
          net = {
            ignore_protocol_stats = true;
          };
          nginx = {
            urls = ["http://localhost/nginx_status"];
          };
        } // cfg.extraInputs;
        outputs = {
          prometheus_client = {
            listen = "[::1]:9273";
            metric_version = 2;
          };
        };
      };
    };
    services.nginx.statusPage = true;

    services.nginx.virtualHosts.${cfg.host} = {
      locations."/metrics" = {
        proxyPass = "http://[::1]:9273/metrics";
        extraConfig = ''
          allow fd8f:d15b:9f40::/48;
          allow ::/8;
          deny all;
        '';
      };
    };
  };
}
