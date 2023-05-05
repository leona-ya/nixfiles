{ ... }: {
  services.youtrack = {
    enable = true;
    port = 7012;
    virtualHost = "yt.leona.is";
  };

  services.nginx.virtualHosts."yt.leona.is" = {
    enableACME = true;
    kTLS = true;
    forceSSL = true;
  };
 
}
