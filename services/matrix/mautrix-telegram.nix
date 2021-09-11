{ config, lib, ... }:

{
  em0lar.secrets."matrix/mautrix-telegram-environment" = {};
  services.mautrix-telegram = {
    enable = true;
    environmentFile = config.em0lar.secrets."matrix/mautrix-telegram-environment".path;
    serviceDependencies = [ "matrix-synapse.service" ];
    settings = {
      homeserver = {
        address = "https://matrix.labcode.de:443";
        domain = "labcode.de";
      };

      appservice = {
        bot_username = "tgbot";
        provisioning.enabled = false;
        id = "tg";
        public = {
          enabled = true;
          prefix = "/public";
          external = "https://mautrix-telegram.labcode.de/public";
        };
        hostname = "::1";
        port = 8010;
      };

      bridge = {
        relaybot.authless_portals = false;
        permissions = {
          "@leo:labcode.de" = "admin";
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

  services.nginx.virtualHosts."mautrix-telegram.labcode.de" = {
    forceSSL = true;
    enableACME = true;
    locations."/public/".proxyPass = "http://[::1]:8010/public/";
  };
}
