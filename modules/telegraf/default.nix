{ pkgs, lib, config, ... }:
let
  cfg = config.l.telegraf;

in
{
  options.l.telegraf = with lib; {
    enable = mkEnableOption "leona telegraf";
    host = mkOption { type = types.str; };
    extraInputs = mkOption {
      type = types.attrs;
      default = { };
    };
    diskioDisks = mkOption { type = types.listOf types.str; };
    allowedNet = mkOption {
      type = types.str;
      default = "fd8f:d15b:9f40::/48";
    };
  };
  config = lib.mkIf cfg.enable {
    services.telegraf = {
      enable = true;
      extraConfig = {
        agent.interval = "20s";
        inputs = {
          mem = { };
          conntrack = {
            files = [ "nf_conntrack_count" "nf_conntrack_max" ];
            dirs = [ "/proc/sys/net/netfilter" ];
          };
          cpu = {
            percpu = false;
            totalcpu = true;
          };
          disk = {
            ignore_fs = [ "tmpfs" "devtmpfs" "devfs" "iso9660" "overlay" "aufs" "squashfs" ];
          };
          diskio = {
            devices = cfg.diskioDisks;
          };
          exec = [{
            commands = [ "${pkgs.fc-telegraf-collect-psi}/bin/collect_psi" ];
            timeout = "10s";
            data_format = "json";
            json_name_key = "name";
            tag_keys = [ "period" "extent" ];
          }];
          kernel = { };
          netstat = { };
          net = {
            ignore_protocol_stats = true;
          };
          #          nginx = {
          #            urls = ["http://localhost/nginx_status"];
          #          };
          postgresql = lib.mkIf config.services.postgresql.enable {
            address = "host=/run/postgresql user=telegraf database=postgres";
          };
          postgresql_extensible = lib.mkIf config.services.postgresql.enable [{
            address = "host=/run/postgresql user=telegraf dbname=postgres";
            query = [
              {
                sqlquery = "SELECT datname, state,count(datname) FROM pg_catalog.pg_stat_activity GROUP BY datname,state";
                measurement = "pg_stat_activity";
              }
            ];
          }];
          processes = { };
          system = { };
          systemd_units = { };
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
    #    services.nginx.statusPage = true;

    services.nginx.virtualHosts."${config.networking.hostName}.wg.net.leona.is" = {
      listen = [{
        addr = "${cfg.host}";
        port = 80;
      }];
      locations."/metrics" = {
        proxyPass = "http://[::1]:9273/metrics";
        extraConfig = ''
          allow ${cfg.allowedNet};
          allow ::/8;
          deny all;
        '';
      };
    };
    services.postgresql.ensureUsers = [
      { name = "telegraf"; }
    ];
    systemd.services.postgresql.postStart = lib.mkIf config.services.postgresql.enable ''
      $PSQL -tAc 'GRANT pg_read_all_stats TO telegraf' -d postgres
    '';
  };
}
