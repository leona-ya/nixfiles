{ config, pkgs, ... }:

{
  l.sops.secrets."services/monitoring/prometheus/alertmanager_bot_env" = {};

  systemd.services.alertmanager-bot = {
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.alertmanager-bot}/bin/alertmanager-bot";
      EnvironmentFile = config.sops.secrets."services/monitoring/prometheus/alertmanager_bot_env".path;
      DynamicUser = true;
      StateDirectory = "alertmanager-bot";
      Restart = "always";
      RestartSec = 30;
    };
    environment = {
      TELEGRAM_ADMIN = "127273642";
      STORE = "bolt";
      BOLT_PATH = "/var/lib/alertmanager-bot/bolt.db";
    };
  };

  services.nginx.virtualHosts."alertmanager-bot.leona.is" = {
    enableACME = true;
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://[::1]:8080/";
      extraConfig = ''
        allow 2a03:4000:f:85f::1/64;
        allow 37.120.184.164/32;
        deny all;
      '';
    };
  };
}
