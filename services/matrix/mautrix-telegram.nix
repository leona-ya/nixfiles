{ config, lib, ... }:

{
  l.sops.secrets."services/matrix/mautrix_telegram_environment" = {};
  services.mautrix-telegram = {
    enable = true;
    environmentFile = config.sops.secrets."services/matrix/mautrix_telegram_environment".path;
    serviceDependencies = [ "matrix-synapse.service" ];
    settings = {
      homeserver = {
        address = "https://matrix.leona.is:443";
        domain = "leona.is";
      };

      appservice = {
        bot_username = "tgbot";
        provisioning.enabled = false;
        id = "tg";
        public = {
          enabled = true;
          prefix = "/public";
          external = "https://mautrix-telegram.leona.is/public";
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

  users = {
    users.mautrix-telegram = {
    	group = "mautrix-telegram";
    	isSystemUser = true;
    };
    groups.mautrix-telegram = {};
  };

  systemd.services.mautrix-telegram = {
    serviceConfig = {
      DynamicUser = lib.mkForce false;
      User = "mautrix-telegram";
      Group = "mautrix-telegram";
    };
  };

  services.nginx.virtualHosts."mautrix-telegram.leona.is" = {
    forceSSL = true;
    enableACME = true;
    kTLS = true;
    locations."/public/".proxyPass = "http://[::1]:8010/public/";
  };
}
