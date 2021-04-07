{ config, lib, pkgs, hosts, ... }:

{
  services.prometheus = {
    enable = true;
    globalConfig.scrape_interval = "30s";
    webExternalUrl = "https://prometheus.em0lar.dev/";

    scrapeConfigs = [
      {
        job_name = "telegraf";
        metrics_path = "/metrics";
        static_configs = [
          {
            targets = [
              "[fd8f:d15b:9f40:102:5c52:b6ff:fee2:db4d]" # beryl
              "[fd8f:d15b:9f40:102:945b:9eff:fe23:2caa]" # foros
              "[fd8f:d15b:9f40:102:3016:54ff:fe12:f68c]" # ladon
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
              for = "5m";
              labels = {
                severity = "warning";
              };
              annotations = {
                summary = "WARNING - {{ $labels.instance }} down";
                description = "{{ $labels.instance }} has been down for more than 5 minutes.";
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
                summary = "CRITICAL - {{ $labels.instance }} down";
                description = "{{ $labels.instance }} has been down for more than 15 minutes.";
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
                summary = "WARNING - Disk of {{ $labels.host }} is almost full";
                description = "Disk is almost full\n  VALUE = {{ $value }}\n  LABELS: {{ $labels }}";
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
                summary = "CRITICAL - Disk of {{ $labels.host }} is almost full";
                description = "Disk is almost full\n  VALUE = {{ $value }}\n  LABELS: {{ $labels }}";
              };
            }
            {
              alert = "LowStoragePredict";
              expr = "predict_linear(disk_free{path!=\"/nix/store\"}[1h], 8 * 3600) < 0";
              for = "30m";
              labels = {
                severity = "warning";
              };
              annotations = {
                summary = "WARNING - Host disk of {{ $labels.host }} will fill in 8 hours";
                description = "Disk will fill in 8 hours at current write rate\n  VALUE = {{ $value }}\n  LABELS: {{ $labels }}";
              };
            }
            {
              alert = "LowStoragePredict";
              expr = "predict_linear(disk_free{path!=\"/nix/store\"}[1h], 4 * 3600) < 0";
              for = "60m";
              labels = {
                severity = "critical";
              };
              annotations = {
                summary = "CRITICAL - Host disk of {{ $labels.host }} will fill in 4 hours";
                description = "Disk will fill in 4 hours at current write rate\n  VALUE = {{ $value }}\n  LABELS: {{ $labels }}";
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
                summary = "WARNING - {{ $labels.host }} is low on system memory";
                description = "{{ $labels.host }} is low on system memory\n  VALUE = {{ $value }}\n  LABELS: {{ $labels }}";
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
                summary = "CRITICAL - {{ $labels.host }} is low on system memory";
                description = "{{ $labels.host }} is low on system memory\n  VALUE = {{ $value }}\n  LABELS: {{ $labels }}";
              };
            }
            {
              alert = "HostSystemdServiceCrashed";
              expr = "systemd_units_active_code{active=\"failed\"} == 1";
              for = "5m";
              labels = {
                severity = "critical";
              };
              annotations = {
                summary = "CRITICAL - A systemd unit on {{ $labels.host }} has failed";
                description = "A systemd unit on {{ $labels.host }} has failed\n  VALUE = {{ $value }}\n  LABELS: {{ $labels }}";
              };
            }
          ];
        }];
      }
    ];
  };
}
