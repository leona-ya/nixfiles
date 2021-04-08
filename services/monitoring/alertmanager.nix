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
        smtp_from = "no-reply@labcode.de";
        smtp_smarthost = "mail.labcode.de:587";
        smtp_auth_username = smtp_from;
        smtp_auth_password = "\${ALERTMANAGER_MAIL_PASSWORD}";
        opsgenie_api_url = "https://api.eu.opsgenie.com";
        opsgenie_api_key = "\${ALERTMANAGER_OPSGENIE_API_KEY}";
      };
      route = {
        group_by = ["alertname" "cluster" "service"];
        group_wait = "15s";
        group_interval = "1m";
        repeat_interval = "6h";
        receiver = "info";
        routes = [
          {
            match.severity = "warning";
            receiver = "warning";
          }
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
          name = "critical";
          opsgenie_configs = [{
           priority = "P1";
           message = alert_message;
          }];
          email_configs = [{
            to = "em0lar@em0lar.de";
            headers.subject = "[ALERT] " + alert_message;
          }];
        }
        {
          name = "warning";
          opsgenie_configs = [{
           message = alert_message;
           priority = "P2";
         }];
        }
        {
          name = "info";
          opsgenie_configs = [{
            message = alert_message;
            priority = "P3";
          }];
        }
      ];
    };
  };
}
