{ config, lib, ... }: {
  options.l.monitoring = {
    enable = lib.mkEnableOption "leona monitoring" // { default = true; };
    logs = {
      enable = lib.mkEnableOption "log collection" // { default = config.l.monitoring.enable; };
    };
    metrics = {
      enable = lib.mkEnableOption "metrics collection" // { default = config.l.monitoring.enable; };
    };
  };

  config = lib.recursiveUpdate (lib.mkIf config.l.monitoring.metrics.enable {
    services.vmagent = {
      enable = true;
      remoteWrite.url = "https://metrics.mon.leona.is/api/v1/write";
      extraArgs = [
        "-remoteWrite.tlsCertFile=\${CREDENTIALS_DIRECTORY}/mtls_cert.pem"
        "-remoteWrite.tlsKeyFile=\${CREDENTIALS_DIRECTORY}/mtls_key.pem"
      ];
      prometheusConfig = {
        scrape_configs = [
          {
            job_name = "node";
            metrics_path = "/metrics";
            static_configs = [
              {
                targets = ["127.0.0.1:${toString config.services.prometheus.exporters.node.port}"];
              }
            ];
          }
          {
            job_name = "systemd";
            metrics_path = "/metrics";
            static_configs = [
              {
                targets = ["127.0.0.1:${toString config.services.prometheus.exporters.systemd.port}"];
              }
            ];
          }
        ] ++ lib.optionals config.services.postgresql.enable [
          {
            job_name = "postgres";
            metrics_path = "/metrics";
            static_configs = [
              {
                targets = ["127.0.0.1:${toString config.services.prometheus.exporters.postgres.port}"];
              }
            ];
          }
        ];
        global = {
          external_labels = {
            instance = config.networking.fqdn;
          };
          scrape_interval = "30s";
        };
      };
    };
    systemd.services.vmagent.serviceConfig.LoadCredential = [
      "mtls_cert.pem:/var/lib/acme/${config.networking.fqdn}/fullchain.pem"
      "mtls_key.pem:/var/lib/acme/${config.networking.fqdn}/key.pem"
    ];
    services.prometheus.exporters = {
      node = {
        enable = true;
        listenAddress = "127.0.0.1";
      };
      postgres = lib.mkIf config.services.postgresql.enable {
        enable = true;
        dataSourceName = "user=postgres-exporter database=postgres host=/run/postgresql";
        listenAddress = "127.0.0.1";
      };
      systemd = {
        enable = true;
        listenAddress = "127.0.0.1";
      };
    };
    services.postgresql.ensureUsers = [
      { name = "postgres-exporter"; }
    ];
    systemd.services.postgresql.postStart = lib.mkIf config.services.postgresql.enable ''
      $PSQL -tAc 'GRANT pg_read_all_stats TO "postgres-exporter"' -d postgres
    '';
  }) (lib.mkIf config.l.monitoring.logs.enable {
    services.alloy = {
      enable = true;
    };

    environment.etc."alloy/config.alloy".text = ''
      loki.write "global_vl" {
        endpoint {
          url = "https://logs.mon.leona.is/insert/loki/api/v1/push?_msg_field=MESSAGE"
          tls_config {
            ca_file = "/etc/ssl/certs/ca-certificates.crt"
            cert_file = "/run/credentials/alloy.service/mtls_cert.pem"
            key_file = "/run/credentials/alloy.service/mtls_key.pem"
          }
        }

        external_labels = {
          instance = "${config.networking.fqdn}",
        }
      }

      loki.relabel "journal" {
        forward_to = []
        rule {
          source_labels = ["__journal__systemd_unit"]
          target_label = "systemd_unit"
        }
        rule {
          source_labels = ["__journal_syslog_identifier"]
          target_label = "syslog_identifier"
        }
      }

      loki.source.journal "journal" {
        forward_to = [loki.write.global_vl.receiver]
        relabel_rules = loki.relabel.journal.rules
        format_as_json = true
      }
    '';

    systemd.services.alloy.serviceConfig.LoadCredential = [
      "mtls_cert.pem:/var/lib/acme/${config.networking.fqdn}/fullchain.pem"
      "mtls_key.pem:/var/lib/acme/${config.networking.fqdn}/key.pem"
    ];
  });
}
