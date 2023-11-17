{ config, ... }: {
  l.sops.secrets."services/plausible/secret_keybase" = {};
  l.sops.secrets."services/plausible/admin_user_password" = {};
  l.sops.secrets."all/mail/no_reply_password" = {};

  services.plausible = {
    enable = true;
    server = {
      baseUrl = "https://lytics.leona.is";
      secretKeybaseFile = config.sops.secrets."services/plausible/secret_keybase".path;
      port = 8723;
    };
    adminUser = {
      name = "leona";
      email = "noc@leona.is";
      passwordFile = config.sops.secrets."services/plausible/admin_user_password".path;
      activate = true;
    };
    mail = {
      email = "no-reply@leona.is";
      smtp = {
        user = "no-reply@leona.is";
        hostAddr = "mail.leona.is";
        hostPort = 465;
        enableSSL = true;
        passwordFile = config.sops.secrets."all/mail/no_reply_password".path;
      };
    };
  };

  services.nginx.virtualHosts."lytics.leona.is" = {    
    enableACME = true;
    forceSSL = true;
    kTLS = true;
    locations."/" = {
      proxyPass = "http://localhost:8723";
    };
  };
}
