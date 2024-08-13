{ config, lib, ... }: {
  services.matrix-synapse.settings.app_service_config_files = [
    "/var/lib/heisenbridge/registration.yml"
    #"/var/lib/mautrix-telegram/telegram-registration.yaml"
  ];

  # Heisenbridge
  services.heisenbridge = {
    enable = true;
    homeserver = "http://[::1]:8008";
    owner = "@leona:leona.is";
  };

  # Telegram
  l.sops.secrets."services/matrix/mautrix_telegram_environment" = { };
  services.mautrix-telegram = {
    enable = false;
    environmentFile = config.sops.secrets."services/matrix/mautrix_telegram_environment".path;
    serviceDependencies = [ "matrix-synapse.service" ];
    settings = {
      homeserver = {
        address = "http://[::1]:8008";
        domain = "leona.is";
      };

      appservice = {
        bot_username = "tgbot";
        provisioning.enabled = false;
        id = "tg";
        public = {
          enabled = true;
          prefix = "/public";
          external = "https://mautrix-telegram.matrix.leona.is/public";
        };
        hostname = "::1";
        port = 8010;
      };

      bridge = {
        relaybot.authless_portals = false;
        permissions = {
          "@leona@leona.is" = "admin";
        };

        username_template = "tg_{userid}";
        alias_template = "tg_{groupname}";
        displayname_template = "{displayname} (TG)";
      };
    };
  };


#  services.nginx.virtualHosts."mautrix-telegram.matrix.leona.is" = {
#    forceSSL = true;
#    kTLS = true;
#    locations."/public/".proxyPass = "http://[::1]:8010/public/";
#  };
}
