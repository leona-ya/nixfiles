{ config, lib, ... }:

{
  l.sops.secrets = {
    "services/netbox/secret_key".owner = "netbox";
    "services/netbox/vouch_proxy_env".owner = "root";
  };

  services.netbox = {
    enable = true;
    secretKeyFile = config.sops.secrets."services/netbox/secret_key".path;
    extraConfig = ''
      REMOTE_AUTH_ENABLED = True;
      REMOTE_AUTH_HEADER = 'HTTP_X_AUTH_REMOTE_USER';
      REMOTE_AUTH_AUTO_CREATE_USER = True;
    '';
  };

  services.postgresql = {
    enable = true;
    ensureDatabases = [ "netbox" ];
    ensureUsers = [
      { name = "netbox";
        ensurePermissions."DATABASE netbox" = "ALL PRIVILEGES";
      }
    ];
  };

  services.nginx.virtualHosts."netbox.leona.is" = {
    enableACME = true;
    forceSSL = true;
    kTLS = true;
    locations."/" = {
      proxyPass = "http://[::1]:8001";
      proxyWebsockets = true;
      extraConfig = ''
        auth_request_set $auth_resp_x_vouch_email $upstream_http_x_vouch_user;
        auth_request_set $auth_resp_x_vouch_username $upstream_http_x_vouch_idp_claims_preferred_username;
        proxy_set_header X-Auth-Remote-User $auth_resp_x_vouch_username;
      '';
    };
    locations."/static/".root = "/var/lib/netbox";
  };
  users.users.nginx.extraGroups = [ "netbox" ];

  services.vouch-proxy = {
    enable = true;
    servers."netbox.leona.is" = {
      clientId = "netbox";
      port = 12302;
      environmentFiles = [ config.sops.secrets."services/netbox/vouch_proxy_env".path ];
    };
  };
}
