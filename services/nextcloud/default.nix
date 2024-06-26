{ pkgs, config, ... }:

{
  l.sops.secrets."services/nextcloud/admin_password".owner = "nextcloud";
  services.nextcloud = {
    enable = true;
    package = pkgs.nextcloud29;
    hostName = "cloud.leona.is";

    https = true;

    autoUpdateApps.enable = true;
    autoUpdateApps.startAt = "05:00:00";

    notify_push = {
      enable = true;
      bendDomainToLocalhost = true;
    };

    config = {
      adminuser = "admin";
      adminpassFile = config.sops.secrets."services/nextcloud/admin_password".path;
    };

    settings = {
      trusted_domains = [
        "cloud.maroni.me"
      ];
      overwriteprotocol = "https";

      dbtype = "pgsql";
      dbuser = "nextcloud";
      dbhost = "/run/postgresql"; # nextcloud will add /.s.PGSQL.5432 by itself
      dbname = "nextcloud";

      default_phone_region = "DE";

      forwarded_for_headers = [
        "HTTP_X_FORWARDED_FOR"
        "HTTP_X_REAL_IP"
      ];
    };
  };
  services.postgresql = {
    enable = true;
    ensureDatabases = [ "nextcloud" ];
    ensureUsers = [
      {
        name = "nextcloud";
        ensureDBOwnership = true;
      }
    ];
  };
  systemd.services."nextcloud-setup" = {
    requires = [ "postgresql.service" ];
    after = [ "postgresql.service" ];
  };
  services.nginx.virtualHosts."${config.services.nextcloud.hostName}" = {
    enableACME = true;
    forceSSL = true;
    kTLS = true;
    serverAliases = config.services.nextcloud.settings.trusted_domains;
  };
}
