{
  config,
  lib,
  pkgs,
  ...
}:
{
  l.sops.secrets = {
    "services/gitlab/oidc-secret".owner = "gitlab";
    "services/gitlab/initial-root-password".owner = "gitlab";
    "services/gitlab/mail".owner = "gitlab";
    "services/gitlab/secret".owner = "gitlab";
    "services/gitlab/otp-secret".owner = "gitlab";
    "services/gitlab/db-secret".owner = "gitlab";
    "services/gitlab/jws-secret".owner = "gitlab";
    "services/gitlab/activerecord-primary-secret".owner = "gitlab";
    "services/gitlab/activerecord-deterministic-secret".owner = "gitlab";
    "services/gitlab/activerecord-salt".owner = "gitlab";
  };

  services.gitlab = {
    enable = true;

    smtp = {
      enable = true;
      username = "gitlab@forkspace.net";
      passwordFile = config.sops.secrets."services/gitlab/mail".path;
      domain = "forkspace.net";
      address = "mail.leona.is";
      port = 465;
      tls = true;
      enableStartTLSAuto = false;
    };

    host = "forkspace.net";
    port = 443;
    https = true;

    initialRootPasswordFile = config.sops.secrets."services/gitlab/initial-root-password".path;
    secrets = {
      secretFile = config.sops.secrets."services/gitlab/secret".path;
      otpFile = config.sops.secrets."services/gitlab/otp-secret".path;
      dbFile = config.sops.secrets."services/gitlab/db-secret".path;
      jwsFile = config.sops.secrets."services/gitlab/jws-secret".path;
      activeRecordPrimaryKeyFile = config.sops.secrets."services/gitlab/activerecord-primary-secret".path;
      activeRecordDeterministicKeyFile =
        config.sops.secrets."services/gitlab/activerecord-deterministic-secret".path;
      activeRecordSaltFile = config.sops.secrets."services/gitlab/activerecord-salt".path;
    };

    sidekiq.concurrency = 1;
    puma.workers = 2;

    extraConfig = {
      gitlab = {
        username_changing_enabled = false;
        email_from = "gitlab@forkspace.net";
        email_display_name = "forkspace";
        email_reply_to = "no-reply@forkspace.net";
      };
      incoming_email = {
        enabled = true;
        mailbox = "inbox";
        address = "gitlab+%{key}@forkspace.net";
        user = config.services.gitlab.smtp.username;
        password._secret = config.services.gitlab.smtp.passwordFile;
        host = "mail.leona.is";
        port = 993;
        ssl = true;
        start_tls = false;
        expunge_deleted = true;
      };
      omniauth = {
        enabled = true;
        allow_single_sign_on = [ "lkc" ];
        allow_bypass_two_factor = [ "lkc" ];
        block_auto_created_users = false;
        auto_link_user = [ "lkc" ];
        providers = [
          {
            name = "lkc";
            label = "auth.leona.is";
            args = {
              name = "lkc";
              strategy_class = "OmniAuth::Strategies::OpenIDConnect";
              scope = [
                "openid"
                "profile"
                "email"
              ];
              response_type = "code";
              issuer = "https://auth.leona.is/realms/leona";
              discovery = true;
              client_auth_method = "query";
              uid_field = "preferred_username";
              send_scope_to_token_endpoint = "false";
              pkce = true;
              client_options = {
                identifier = "forkspace-gitlab";
                secret._secret = config.sops.secrets."services/gitlab/oidc-secret".path;
                redirect_uri = "https://forkspace.net/users/auth/lkc/callback";
              };
            };
          }
        ];
      };
    };
  };

  systemd.services.gitlab.serviceConfig.Restart = lib.mkForce "always";
  services.openssh = {
    extraConfig = ''
      Match User gitlab
        AuthorizedKeysFile ${config.users.users.gitlab.home}/.ssh/authorized_keys
    '';
  };
  services.nginx.virtualHosts."forkspace.net" = {
    enableACME = true;
    forceSSL = true;
    kTLS = true;
    locations."/" = {
      proxyPass = "http://unix://run/gitlab/gitlab-workhorse.socket";
      proxyWebsockets = true;
    };
  };

  #  services.gitlab.backup = {
  #    startAt = [ "0/2:50" ];
  #    keepTime = 4;
  #  };
}
