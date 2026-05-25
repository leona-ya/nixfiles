{ pkgs, ... }:
{
  services.youtrack = {
    enable = true;
    environmentalParameters.listen-port = 7012;
    virtualHost = "yt.infinitespace.dev";
    package = pkgs.youtrack;
  };

  security.acme.certs."yt.infinitespace.dev".group = "nginx";
  services.nginx.virtualHosts."yt.infinitespace.dev" = {
    useACMEHost = "yt.infinitespace.dev";
    kTLS = true;
    forceSSL = true;
  };

}
