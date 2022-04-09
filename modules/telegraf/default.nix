{ pkgs, lib, config, ... }:
let
  cfg = config.l.telegraf;

in {
  options.l.telegraf = with lib; {
    enable = mkEnableOption "leona telegraf";
    host = mkOption { type = types.str; };
    extraInputs = mkOption {
      type = types.attrs;
      default = {};
    };
    diskioDisks = mkOption { type = types.listOf types.str; };
  };
  config = lib.mkIf cfg.enable {
    services.telegraf = {
      enable = true;
      extraConfig = {
        agent.interval = "20s";
        inputs = {
          system = { };
          mem = { };
          cpu = { };
          disk = {
            ignore_fs = ["tmpfs" "devtmpfs" "devfs" "iso9660" "overlay" "aufs" "squashfs"];
          };
          diskio = {
            devices = cfg.diskioDisks;
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
            expiration_interval = "120s";
            export_timestamp = true;
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
