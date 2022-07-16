{ config, ... }:

let
  alert_message = "{{ .CommonAnnotations.summary }}";
in {
  l.sops.secrets = {
    "services/monitoring/prometheus/alertmanager_env" = {};
    "services/monitoring/prometheus/vouch_proxy_env" = {};
  };

  systemd.services.alertmanager.serviceConfig.EnvironmentFile = [ config.sops.secrets."services/monitoring/prometheus/alertmanager_env".path ];

  services.nginx.virtualHosts."alertmanager.leona.is" = {
    locations."/" = {
      proxyPass = "http://127.0.0.1:${toString config.services.prometheus.alertmanager.port}/";
    };
    enableACME = true;
    forceSSL = true;
  };

  services.vouch-proxy = {
    enable = true;
    servers."alertmanager.leona.is" = {
      clientId = "prometheus";
      port = 12301;
      environmentFiles = [ config.sops.secrets."services/monitoring/prometheus/vouch_proxy_env".path ];
    };
  };

  services.prometheus.alertmanager = {
    enable = true;
    webExternalUrl = "https://alertmanager.leona.is/";
    listenAddress = "127.0.0.1";
    extraFlags = [
      "--cluster.listen-address="
    ];

    configuration = {
      global = rec {
        smtp_from = "no-reply@leona.is";
        smtp_smarthost = "mail.leona.is:587";
        smtp_auth_username = smtp_from;
        smtp_auth_password = "\${ALERTMANAGER_MAIL_PASSWORD}";
      };
      route = {
        group_by = ["alertname" "cluster" "service"];
        group_wait = "15s";
        group_interval = "1m";
        repeat_interval = "6h";
        receiver = "warning";
        routes = [
          {
            match.severity = "critical";
            receiver = "critical";
          }
        ];
      };
      inhibit_rules = [
        {
          source_match = {
            severity = "critical";
          };
          target_match = {
            severity = "warning";
          };
          equal = ["alertname" "cluster" "service"];
        }
      ];
      receivers = [
        {
          name = "warning";
          webhook_configs = [{
            url = "https://alertmanager-bot.leona.is";
            send_resolved = true;
          }];
        }
        {
          name = "critical";
          webhook_configs = [{
            url = "https://alertmanager-bot.leona.is";
            send_resolved = true;
          }];
          email_configs = [{
            to = "leona@leona.is";
            headers.subject = "[ALERT] " + alert_message;
          }];
        }
      ];
    };
  };
}
