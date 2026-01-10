{ config, ... }: {
  l.sops.secrets."all/mail/no_reply_password".owner = "discourse";
  l.sops.secrets."services/stag-discourse/admin_user_pw".owner = "discourse";
  services.nginx.validateConfigFile = false;
  services.discourse = {
    enable = true;
    plugins = with config.services.discourse.package.plugins; [
      discourse-prometheus
    ];
    admin = {
      email = "staging@leona.is";
      username = "leona";
      fullName = "Alicia Admin";
      passwordFile = config.sops.secrets."services/stag-discourse/admin_user_pw".path;
    };
    hostname = "discourse.stag.infinitespace.dev";
    database.ignorePostgresqlVersion = true;
    siteSettings = {
      posting = {
        min_post_length = 5;
        min_first_post_length = 5;
        min_personal_message_post_length = 5;
      };
    };
    unicornTimeout = 900;
    nginx.enable = true;
    mail.notificationEmailAddress = "no-reply@leona.is";
    mail.outgoing = {
      username = "no-reply@leona.is";
      passwordFile = config.sops.secrets."all/mail/no_reply_password".path;
      serverAddress = "mail.leona.is";
      port = 465;
      forceTLS = true;
      enableStartTLSAuto = false;
    };
  };
}
