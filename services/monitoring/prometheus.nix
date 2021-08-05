{ config, lib, pkgs, hosts, ... }:

{
  em0lar.secrets."prometheus-basic-auth".owner = "nginx";

  services.nginx.virtualHosts."prometheus.em0lar.dev" = {
    locations."/" = {
      proxyPass = "http://127.0.0.1:${toString config.services.prometheus.port}/";
      basicAuthFile = config.em0lar.secrets."prometheus-basic-auth".path;
    };
    enableACME = true;
    forceSSL = true;
  };

  services.prometheus = {
    enable = true;
    globalConfig = {
      scrape_interval = "30s";
      evaluation_interval = "30s";
    };
    webExternalUrl = "https://prometheus.em0lar.dev/";

    scrapeConfigs = [
      {
        job_name = "telegraf";
        metrics_path = "/metrics";
        static_configs = [
          {
            targets = [
              "[fd8f:d15b:9f40:11:8079:3aff:fe35:9ddc]" # beryl
              "[fd8f:d15b:9f40:11:2c5a:56ff:fe4f:e4c4]" # foros
              "[fd8f:d15b:9f40:11:6cf2:ecff:fe90:8c3c]" # ladon
              "[fd8f:d15b:9f40::1]" # dwd
              "[fd8f:d15b:9f40:0c00::1]" # haku
              "[fd8f:d15b:9f40:0c20::1]" # naiad
              "[fd8f:d15b:9f40:0c21::1]" # myron
            ];
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
              alert = "WireguardHandshakeTooLongAgo";
              expr = "time() - (wireguard_peer_last_handshake_time_ns / 1e+9) > 600";
              for = "0s";
              labels = {
                severity = "warning";
              };
              annotations = {
                summary = "WARN - Wireguard host handshake is more than 10min ago";
                description = "The handshake with the wireguard host with public key {{ $labels.public_key }} is {{ $value }} seconds ago.\n";
              };
            }
            {
              alert = "WireguardHandshakeTooLongAgo";
              expr = "time() - (wireguard_peer_last_handshake_time_ns / 1e+9) > 900";
              for = "0s";
              labels = {
                severity = "critical";
              };
              annotations = {
                summary = "CRIT - Wireguard host handshake is more than 15min ago";
                description = "The handshake with the wireguard host with public key {{ $labels.public_key }} is {{ $value }} seconds ago.\n";
              };
            }
            {
              alert = "BorgBackupTooLongAgo";
              expr = "time() - borgbackup_last_successful_archive_gauge > 97200";
              for = "0s";
              labels = {
                severity = "critical";
              };
              annotations = {
                summary = "CRIT - BorgBackup on {{ $labels.host }} is more than 27h ago";
                description = "The BorgBackup on {{ $labels.host }} ran last at {{ $value }}ssh a.\n";
              };
            }
          ];
        }];
      }
    ];
  };
}
