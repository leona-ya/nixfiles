{ config, ... }:

{
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
      };
      route = {
        group_by = ["alertname" "cluster" "service"];
        group_wait = "30s";
        group_interval = "5m";
        repeat_interval = "6h";
        receiver = "warning";
        routes = [
          {
            match = {
              severity = "critical";
            };
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
          }];
        }
      ];
    };
  };
}
