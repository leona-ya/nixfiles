{ pkgs, lib, config, ... }:

with lib;

let
  cfg = config.services.vouch-proxy;
  format = pkgs.formats.yaml {};
  serverOptions =
    { ... }: {

      options = {
        clientId = mkOption {
          type = types.str;
          description = "OIDC Client ID for server.";
        };
        port = mkOption {
          type = types.int;
          description = "Port of the vouch-proxy server.";
        };
        environmentFiles = mkOption {
          type = with types; nullOr (listOf path);
          default = [ ];
          description = ''
            List of environment files set in the vouch-proxy-<literal>name</literal> systemd service.
            For example the jwt secret and oidc secrets should be set in one of these files.
          '';
        };
        addAuthRequestToMainLocation = mkOption {
          type = types.bool;
          default = false;
          description = "Add auth_request to / location.";
        };
      };
    };
  mkService = domain: serviceConfig:
    let
      settings = recursiveUpdate cfg.globalSettings {
        vouch.port = serviceConfig.port;
        vouch.cookie.domain = domain;
        oauth.client_id = serviceConfig.clientId;
        oauth.callback_url = "https://${domain}/_vouch/auth";
      };
      configFile = format.generate "vouch-proxy-config.yaml" settings;
    in nameValuePair "vouch-proxy-${domain}" {
    description = "vouch-proxy";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    path = [ cfg.package ];

    serviceConfig = {
      Type = "simple";
      DynamicUser = true;
      ExecStart = "${cfg.package}/bin/vouch-proxy -config ${configFile}";
      Restart = "always";
      EnvironmentFile = serviceConfig.environmentFiles;
    };
  };
  mkVirtualHosts = domain: serviceConfig: nameValuePair domain {
    extraConfig = ''
      error_page 401 = @error401;
    '';
    locations."/".extraConfig = ''
      auth_request /_vouch/validate;
    '';
    locations."/_vouch" = {
      proxyPass = "http://127.0.0.1:${toString serviceConfig.port}";
      extraConfig = ''
        proxy_pass_request_body off;
        proxy_set_header Content-Length "";
        # these return values are used by the @error401 call
        auth_request_set $auth_resp_jwt $upstream_http_x_vouch_jwt;
        auth_request_set $auth_resp_err $upstream_http_x_vouch_err;
        auth_request_set $auth_resp_failcount $upstream_http_x_vouch_failcount;
      '';
    };

    locations."@error401".return = "302 https://${domain}/_vouch/login?url=https://$host$request_uri&vouch-failcount=$auth_resp_failcount&X-Vouch-Token=$auth_resp_jwt&error=$auth_resp_err";
  };
in {
  options.services.vouch-proxy = with lib; {
    enable = mkEnableOption "vouch-proxy service";
    package = mkOption {
      default = pkgs.vouch-proxy;
      type = types.package;
      defaultText = "pkgs.vouch-proxy";
      description = "vouch-proxy derivation to use.";
    };
    servers = mkOption {
      type = types.attrsOf (types.submodule serverOptions);
    };
    globalSettings = mkOption {
      type = format.type;
      default = {
        vouch = {
          listen = "127.0.0.1";
          jwt.issuer = "leona SSO";
          allowAllUsers = true;
          headers = {
            claims = [
              "preferred_username"
            ];
          };
          document_root = "/_vouch";
        };
        oauth = {
          provider = "oidc";
          auth_url = "https://auth.leona.is/realms/leona/protocol/openid-connect/auth";
          token_url = "https://auth.leona.is/realms/leona/protocol/openid-connect/token";
          user_info_url = "https://auth.leona.is/realms/leona/protocol/openid-connect/userinfo";
          scopes = [
            "openid"
            "email"
            "profile"
          ];
        };
      };
      description = ''
        Vouch-proxy configuration. Refer to
        <link xlink:href="https://github.com/vouch/vouch-proxy/blob/master/config/config.yml_example"/>
        for details on supported values.
        '';
    };
  };
  config = lib.mkIf cfg.enable {
    systemd.services = mapAttrs' mkService cfg.servers;
    services.nginx.virtualHosts = mapAttrs' mkVirtualHosts cfg.servers;
  };
}
