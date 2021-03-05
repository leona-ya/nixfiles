{ ... }:

{
  services.nginx.virtualHosts = {
    "git.em0lar.de" = {
      enableACME = true;
      forceSSL = true;
      serverAliases = [
        "git.emolar.de"
        "git.labcode.de"
      ];
      locations."/" = {
        extraConfig = "return 301 https://git.em0lar.dev$request_uri;";
      };
    };
    "git.em0lar.dev" = {
      enableACME = true;
      forceSSL = true;
      locations."/".proxyPass = "http://hyperion.int.sig.de.labcode.de:40000";
    };
    "auth.em0lar.de" = {
      enableACME = true;
      forceSSL = true;
      serverAliases = [
        "auth.emolar.de"
        "auth.labcode.de"
      ];
      locations."/" = {
        extraConfig = "return 301 https://auth.em0lar.dev$request_uri;";
      };
    };
    "auth.em0lar.dev" = {
      enableACME = true;
      forceSSL = true;
      locations."/".proxyPass = "http://phoebe.int.sig.de.labcode.de:8080";
    };
    "md.em0lar.dev" = {
      enableACME = true;
      forceSSL = true;
      serverAliases = [
        "md.emolar.de"
        "md.labcode.de"
      ];
      locations."/" = {
        extraConfig = "return 301 https://md.em0lar.de$request_uri;";
      };
    };
    "md.em0lar.de" = {
      enableACME = true;
      forceSSL = true;
      locations."/".proxyPass = "http://hyperion.int.sig.de.labcode.de:40001";
    };
    "matrix.labcode.de" = {
      enableACME = true;
      forceSSL = true;
      locations."/".proxyPass = "http://hyperion.int.sig.de.labcode.de:8008";
    };
  };
}
