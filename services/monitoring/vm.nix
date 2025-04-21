{ lib, ... }: {
  services.victoriametrics = {
    enable = true;
    retentionPeriod = "31d";
  };

  services.victorialogs = {
    enable = true;
  };

  services.nginx.virtualHosts = lib.recursiveUpdate (lib.genAttrs [ "metrics.mon.leona.is" "logs.mon.leona.is" ] (host: { 
    enableACME = true;
    forceSSL = true;
    kTLS = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:8428";
      extraConfig = ''
        if ($ssl_client_s_dn !~ ".*\.leona\.is$") {
          return 403;
        }
        client_max_body_size 50M;
      '';
    };
    extraConfig = ''
      ssl_client_certificate /etc/ssl/certs/ca-certificates.crt;
      ssl_verify_client on;
    '';
  })) {
    "metrics.mon.leona.is".locations."/".proxyPass = "http://127.0.0.1:8428";
    "logs.mon.leona.is".locations."/".proxyPass = "http://127.0.0.1:9428";
  };
}
