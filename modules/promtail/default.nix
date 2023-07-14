{ config, lib, ... }: let
  cfg = config.l.promtail;
in with lib; {
  options.l.promtail = {
    enable = mkEnableOption "leona promtail";
    enableNginx = mkEnableOption "nginx logs";
  };
  config = mkIf cfg.enable {
    services.promtail = {
      enable = true;
      configuration = {
        server = {
          http_listen_port = 3031;
          grpc_listen_port = 0;
          log_level = "debug";
        };
        positions = {
          filename = "/tmp/loki-positions.yaml";
        };
        clients = [{
          url = "https://loki.int.leona.is/loki/api/v1/push";
          tls_config = {
            ca_file = ../../lib/leona-is-ca.crt;
            server_name = "loki.int.leona.is";
          };
        }];
        scrape_configs = [
          {
            job_name = "journal";
            journal = {
              max_age = "12h";
              labels = {
                job = "systemd-journal";
                host = config.networking.hostName;
              };
            };
            relabel_configs = [{
              source_labels = [ "__journal__systemd_unit" ];
              target_label = "unit";
            }];
          }
        ] ++ (lib.optional cfg.enableNginx {
          job_name = "system";
          pipeline_stages = [
              {
                json.expressions = {
                  timestamp = "ms";
                };
              }
              {
                timestamp = {
                  source = "timestamp";
                  format = "Unix";
                };
              }
          ];
          decompression = {
            enabled = true;
            initial_delay = "10s";
            format = "gz";
          };
          static_configs = [{
            targets = ["localhost"];
            labels = {
              job = "nginx-access";
              host = config.networking.hostName;
              __path__ = "/var/log/nginx/loki_access.log.gz";
            };
          }];
        });
      };
    };
    systemd.services."promtail".serviceConfig.SupplementaryGroups = [ "nginx" ];
  };
}