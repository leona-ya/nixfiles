{ config, ... }:

let
  alert_message = "{{ .CommonAnnotations.summary }}";
in {
  em0lar.secrets."alertmanager-env" = {};
  em0lar.secrets."alertmanager-basic-auth".owner = "nginx";

  systemd.services.alertmanager.serviceConfig.EnvironmentFile = [ config.em0lar.secrets."alertmanager-env".path ];

  services.nginx.virtualHosts."alertmanager.em0lar.dev" = {
    locations."/" = {
      proxyPass = "http://127.0.0.1:${toString config.services.prometheus.alertmanager.port}/";
      basicAuthFile = config.em0lar.secrets."alertmanager-basic-auth".path;
    };
    enableACME = true;
    forceSSL = true;
  };

  services.prometheus.alertmanager = {
    enable = true;
    webExternalUrl = "https://alertmanager.em0lar.dev/";
    listenAddress = "127.0.0.1";
    extraFlags = [
      "--cluster.listen-address="
    ];

    configuration = {
      global = rec {
        smtp_from = "no-reply@em0lar.dev";
        smtp_smarthost = "mail.em0lar.dev:587";
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
            url = "https://alertmanager-bot.em0lar.dev";
            send_resolved = true;
          }];
        }
        {
          name = "critical";
          webhook_configs = [{
            url = "https://alertmanager-bot.em0lar.dev";
            send_resolved = true;
          }];
          email_configs = [{
            to = "em0lar@em0lar.de";
            headers.subject = "[ALERT] " + alert_message;
          }];
        }
      ];
    };
  };
}
