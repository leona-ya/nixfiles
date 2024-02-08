{ config, ... }: {
  l.sops.secrets."services/matrix/sliding-sync/env".owner = "root";
  services.matrix-sliding-sync = {
    enable = true;
    environmentFile = config.sops.secrets."services/matrix/sliding-sync/env".path;
    settings = {
      SYNCV3_SERVER = "https://matrix.leona.is";
    };
  };

  services.nginx.virtualHosts."sliding-sync.matrix.leona.is" = {
    forceSSL = true;
    enableACME = true;
    kTLS = true;
    locations = {
      "/" = {
        proxyPass = "http://127.0.0.1:8009";
      };
    };
  };
}
