{
  config,
  lib,
  pkgs,
  ...
}:

{
  l.sops.secrets = {
    "services/netbox/secret_key".owner = "netbox";
    "services/netbox/openid_client_id".owner = "netbox";
    "services/netbox/openid_client_secret".owner = "netbox";
  };

  services.netbox = {
    enable = true;
    package = pkgs.netbox_4_3;
    unixSocket = "/run/netbox/netbox.sock";
    secretKeyFile = config.sops.secrets."services/netbox/secret_key".path;
    extraConfig = ''
      with open("${config.sops.secrets."services/netbox/openid_client_id".path}", "r") as file:
        SOCIAL_AUTH_OIDC_KEY = file.readline()
      with open("${config.sops.secrets."services/netbox/openid_client_secret".path}", "r") as file:
        SOCIAL_AUTH_OIDC_SECRET = file.readline()
    '';
    settings = {
      ALLOWED_HOSTS = [ "netbox.leona.is" ];
      REMOTE_AUTH_ENABLED = true;
      REMOTE_AUTH_BACKEND = "social_core.backends.open_id_connect.OpenIdConnectAuth";
      SOCIAL_AUTH_OIDC_OIDC_ENDPOINT = "https://auth.leona.is/realms/leona";
      REMOTE_AUTH_AUTO_CREATE_USER = true;
      # THis fucking software makes it almost impossible to set this correctly.
      # SOCIAL_AUTH_USER_FIELD_MAPPING = {
      #   "groups" = "groups";
      # };
      # REMOTE_AUTH_AUTO_CREATE_GROUPS = true;
      # REMOTE_AUTH_GROUP_SYNC_ENABLED = true;
      # REMOTE_AUTH_SUPERUSER_GROUPS = [ "superuser" ];
      # REMOTE_AUTH_STAFF_GROUPS = [ "staff" ];
    };
  };

  systemd.services."netbox".serviceConfig.RuntimeDirectory = "netbox";

  services.postgresql = {
    enable = true;
    ensureDatabases = [ "netbox" ];
    ensureUsers = [
      {
        name = "netbox";
        ensureDBOwnership = true;
      }
    ];
  };

  services.nginx.virtualHosts."netbox.leona.is" = {
    enableACME = true;
    forceSSL = true;
    kTLS = true;
    locations."/" = {
      proxyPass = "http://unix:${config.services.netbox.unixSocket}";
      proxyWebsockets = true;
    };
    locations."/static/".alias = "/persist/var/lib/netbox/static/";
  };
  users.users.nginx.extraGroups = [ "netbox" ];
}
