{ pkgs, config, lib, ... }:

{
  em0lar.secrets = {
    "gitea/mail".owner = "gitea";
    "gitea/ssh_deploy_key".owner = "gitea";
  };

  services.postgresql = {
    enable = true;
    ensureDatabases = [ "gitea" ];
    ensureUsers = [
      { name = "gitea";
        ensurePermissions."DATABASE gitea" = "ALL PRIVILEGES";
      }
    ];
  };

  services.gitea = {
    enable = true;
    stateDir = "/var/lib/gitea";
    log.level = "Warn";
    appName = "em0lar's Gitea";
    domain = "git.em0lar.dev";
    rootUrl = "https://git.em0lar.dev/";
    httpAddress = "/run/gitea/gitea.sock";
    cookieSecure = true;
    disableRegistration = true;
    ssh = {
      enable = true;
      clonePort = 2222;
    };

    database = {
      type = "postgres";
      name = "gitea";
      user = "gitea";
    };

    mailerPasswordFile = config.em0lar.secrets."gitea/mail".path;

    settings = {
      mailer = {
        ENABLED = true;
        SUBJECT = "%(APP_NAME)s";
        HOST = "mail.labcode.de:465";
        USER = "no-reply@labcode.de";
        SEND_AS_PLAIN_TEXT = true;
        USE_SENDMAIL = false;
        FROM = "\"em0lar's Gitea\" <no-reply@labcode.de>";
      };

      picture = {
        DISABLE_GRAVATAR = true;
      };

      security = {
        DISABLE_GIT_HOOKS = false;
      };

      server = {
        START_SSH_SERVER = true;
        BUILTIN_SSH_SERVER_USER = "git";
        DISABLE_ROUTER_LOG = true;
        PROTOCOL = "unix";
      };

      service = {
        ALLOW_ONLY_EXTERNAL_REGISTRATION = true;
        ENABLE_NOTIFY_MAIL = true;
      };

      ui = {
        THEMES = "gitea,arc-green";
        DEFAULT_THEME = "arc-green";
      };
    };
  };

  systemd.services.gitea.serviceConfig.ExecStartPre = [
    "${pkgs.coreutils}/bin/ln -sf ${config.em0lar.secrets."gitea/ssh_deploy_key".path} /var/lib/gitea/ssh_deploy_key"
  ];

  services.nginx.virtualHosts = {
    "git.em0lar.de" = {
      enableACME = true;
      forceSSL = true;
      serverAliases = [
        "git.emolar.de"
        "git.labcode.de"
      ];
      locations."/" = {
        extraConfig = "return 301 https://git.em0lar.dev$request_uri;";
      };
    };
    "git.em0lar.dev" = {
      enableACME = true;
      forceSSL = true;
      locations."/".proxyPass = "http://unix:/run/gitea/gitea.sock";
    };
  };
  networking.firewall.allowedTCPPorts = [ 2222 ];
}

