{ pkgs, config, ... }:

let
  cfg = config.services.nextcloud;
in
{
  l.sops.secrets."services/nextcloud/admin_password".owner = "nextcloud";
  services.nextcloud = {
    enable = true;
    package = pkgs.nextcloud31;
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
      dbtype = "pgsql";
      dbuser = "nextcloud";
      dbhost = "/run/postgresql"; # nextcloud will add /.s.PGSQL.5432 by itself
      dbname = "nextcloud";
    };

    settings = {
      trusted_domains = [
        "cloud.maroni.me"
      ];
      overwriteprotocol = "https";

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
  security.acme.certs."${cfg.hostName}" = {
    group = "nginx";
    extraDomainNames = cfg.settings.trusted_domains;
  };
  services.nginx.virtualHosts."${cfg.hostName}" = {
    useACMEHost = cfg.hostName;
    forceSSL = true;
    kTLS = true;
    serverAliases = cfg.settings.trusted_domains;
  };
}
