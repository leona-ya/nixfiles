{ pkgs, ... }:
{
  services.youtrack = {
    enable = true;
    environmentalParameters.listen-port = 7012;
    virtualHost = "yt.leona.is";
    package = pkgs.youtrack;
  };

  security.acme.certs."yt.leona.is".group = "nginx";
  services.nginx.virtualHosts."yt.leona.is" = {
    useACMEHost = "yt.leona.is";
    kTLS = true;
    forceSSL = true;
  };

}
