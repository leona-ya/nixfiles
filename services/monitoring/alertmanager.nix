{ config, ... }:

let
  alert_message = "{{ .CommonAnnotations.summary }}";
in
{
  l.sops.secrets = {
    "services/monitoring/prometheus/alertmanager_env" = { };
    "services/monitoring/prometheus/vouch_proxy_env" = { };
  };

  systemd.services.alertmanager.serviceConfig.EnvironmentFile = [ config.sops.secrets."services/monitoring/prometheus/alertmanager_env".path ];

  services.nginx.virtualHosts."alertmanager.leona.is" = {
    locations."/" = {
      proxyPass = "http://127.0.0.1:${toString config.services.prometheus.alertmanager.port}/";
    };
    enableACME = true;
    forceSSL = true;
    kTLS = true;
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
        group_by = [ "alertname" "cluster" "service" ];
        group_wait = "15s";
        group_interval = "1m";
        repeat_interval = "12h";
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
          equal = [ "alertname" "cluster" "service" ];
        }
      ];
      receivers =
        let
          tg_config = {
            bot_token = "\${ALERTMANAGER_TELEGRAM_TOKEN}";
            chat_id = 127273642;
            api_url = "https://api.telegram.org";
          };
        in
        [
          {
            name = "warning";
            telegram_configs = [ tg_config ];
          }
          {
            name = "critical";
            telegram_configs = [ tg_config ];
            email_configs = [{
              to = "monitoring@leona.is";
              headers.subject = "[ALERT] " + alert_message;
            }];
          }
        ];
    };
  };
}
