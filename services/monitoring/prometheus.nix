{ config, lib, pkgs, hosts, ... }:

let
  hosthelper = import ../../hosts { inherit lib config; };
in {
  l.sops.secrets."services/monitoring/prometheus/vouch_proxy_env" = {};

  services.nginx.virtualHosts."prometheus.leona.is" = {
    locations."/" = {
      proxyPass = "http://127.0.0.1:${toString config.services.prometheus.port}/";
    };
    enableACME = true;
    forceSSL = true;
  };

  services.vouch-proxy = {
    enable = true;
    servers."prometheus.leona.is" = {
      clientId = "prometheus";
      port = 12300;
      environmentFiles = [ config.sops.secrets."services/monitoring/prometheus/vouch_proxy_env".path ];
    };
  };

  services.prometheus = {
    enable = true;
    retentionTime = "32d";
    globalConfig = {
      scrape_interval = "30s";
      evaluation_interval = "30s";
    };
    webExternalUrl = "https://prometheus.leona.is/";

    scrapeConfigs = [
      {
        job_name = "telegraf";
        metrics_path = "/metrics";
        static_configs = [
          {
            targets = hosthelper.groups.monitoring.g_hostnames;
          }
        ];
      }
    ];

    alertmanagers = [ {
      scheme = "http";
      static_configs = [{
        targets = [
          "127.0.0.1:${toString config.services.prometheus.alertmanager.port}"
        ];
      }];
    }];

    rules = map (r: builtins.toJSON r) [
      {
        groups = [{
          name = "infra";
          rules = [
            {
              alert = "InstanceDown";
              expr = "up == 0";
              for = "10m";
              labels = {
                severity = "warning";
              };
              annotations = {
                summary = "WARN - {{ $labels.instance }} down";
                description = "{{ $labels.instance }} has been down for more than 10 minutes.\n";
              };
            }
            {
              alert = "InstanceDown";
              expr = "up == 0";
              for = "15m";
              labels = {
                severity = "critical";
              };
              annotations = {
                summary = "CRIT - {{ $labels.instance }} down";
                description = "{{ $labels.instance }} has been down for more than 15 minutes.\n";
              };
            }
            {
              alert = "HighCPU";
              expr = "(cpu_usage_system + cpu_usage_user) > 85";
              for = "30m";
              labels = {
                severity = "warning";
              };
              annotations = {
                summary = "WARN - CPU of {{ $labels.host }} has a high load";
                description = "CPU has a high load for 30min\n Value: {{ $value }}\n";
              };
            }
            {
              alert = "HighCPU";
              expr = "(cpu_usage_system + cpu_usage_user) > 85";
              for = "60m";
              labels = {
                severity = "critical";
              };
              annotations = {
                summary = "CRIT - CPU of {{ $labels.host }} has a high load";
                description = "CPU has a high load for 60min\n Value: {{ $value }}\n";
              };
            }
            {
              alert = "LowStorage";
              expr = "disk_used_percent{path!=\"/nix/store\"} > 90";
              for = "5m";
              labels = {
                severity = "warning";
              };
              annotations = {
                summary = "WARN - Disk of {{ $labels.host }} is almost full";
                description = "Disk is almost full\n Value: {{ $value }}\n";
              };
            }
            {
              alert = "LowStorage";
              expr = "disk_used_percent{path!=\"/nix/store\"} > 95";
              for = "5m";
              labels = {
                severity = "critical";
              };
              annotations = {
                summary = "CRIT - Disk of {{ $labels.host }} is almost full";
                description = "Disk is almost full\n Value: {{ $value }}\n";
              };
            }
            {
              alert = "LowStoragePredict";
              expr = "predict_linear(disk_free{path!=\"/nix/store\", path!=\"/boot\"}[1h], 5 * 3600) < 0";
              for = "30m";
              labels = {
                severity = "warning";
              };
              annotations = {
                summary = "WARN - Host disk of {{ $labels.host }} will fill in 5 hours";
                description = "Disk will fill in 5 hours at current write rate\n Value: {{ $value }}\n";
              };
            }
            {
              alert = "LowStoragePredict";
              expr = "predict_linear(disk_free{path!=\"/nix/store\", path!=\"/boot\"}[1h], 3 * 3600) < 0";
              for = "60m";
              labels = {
                severity = "critical";
              };
              annotations = {
                summary = "CRIT - Host disk of {{ $labels.host }} will fill in 3 hours";
                description = "Disk will fill in 3 hours at current write rate\n Value: {{ $value }}";
              };
            }
            {
              alert = "LowMemory";
              expr = "mem_used_percent > 80";
              for = "1m";
              labels = {
                severity = "warning";
              };
              annotations = {
                summary = "WARN - {{ $labels.host }} is low on system memory";
                description = "{{ $labels.host }} is low on system memory\n Value: {{ $value }}\n";
              };
            }
            {
              alert = "LowMemory";
              expr = "mem_used_percent > 80";
              for = "15m";
              labels = {
                severity = "critical";
              };
              annotations = {
                summary = "CRIT - {{ $labels.host }} is low on system memory";
                description = "{{ $labels.host }} is low on system memory\n Value: {{ $value }}\n";
              };
            }
            {
              alert = "HostSystemdServiceCrashed";
              expr = "systemd_units_active_code{active=\"failed\"} > 0";
              for = "5m";
              labels = {
                severity = "critical";
              };
              annotations = {
                summary = "CRIT - A systemd unit on {{ $labels.host }} has failed";
                description = "A systemd unit on {{ $labels.host }} has failed\n Value: {{ $value }}\n";
              };
            }
            {
              alert = "HttpStatusCodeWrong";
              expr = "http_response_http_response_code != 200";
              for = "5m";
              labels = {
                severity = "critical";
              };
              annotations = {
                summary = "CRIT - HTTP service {{ $labels.server }} responded incorrect";
                description = "The HTTP service {{ $labels.service }} responded with {{ $value }} instead of 200.\n";
              };
            }
            {
              alert = "BorgBackupTooLongAgo";
              expr = "time() - borgbackup_last_successful_archive > 97200";
              for = "0s";
              labels = {
                severity = "critical";
              };
              annotations = {
                summary = "CRIT - BorgBackup on {{ $labels.host }} is more than 27h ago";
                description = "The BorgBackup on {{ $labels.host }} ran last at {{ $value }}.\n";
              };
            }
            {
              alert = "MDRaidDiskFailed";
              expr = "mdstat_DisksFailed > 97200";
              for = "0s";
              labels = {
                severity = "critical";
              };
              annotations = {
                summary = "CRIT - MDRaid Disk failure on {{ $labels.host }}";
                description = "A disk on {{ $labels.host }} in {{ $labels.Name }} failed.\n";
              };
            }
          ];
        }];
      }
    ];
  };
}
