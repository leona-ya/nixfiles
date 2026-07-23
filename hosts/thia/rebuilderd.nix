{ pkgs, ... }:
{
  services.rebuilderd = {
    enable = true;
    package = pkgs.rebuilderd.overrideAttrs (fA: {
      src = pkgs.fetchFromGitLab {
        domain = "forkspace.net";
        owner = "leona-bachelor-thesis/rebuilderd-tooling";
        repo = "rebuilderd";
        rev = "653aad80d17d7d32e6ebb4635c8fca5e3508dfc0";
        hash = "sha256-dISuzNDgsi2kj5umHOiPdR9vKhhMN3h2Pdpjq8Aeho0=";
      };
    });
    settings.http.bind_addr = "0.0.0.0:62217";
  };

  networking.firewall.allowedTCPPorts = [ 62217 ];

  services.nginx.virtualHosts = {
    "rebuilderd.ba.leona.is" = {
      forceSSL = true;
      enableACME = true;
      locations."/" = {
        proxyPass = "http://localhost:62217";
      };
    };
  };
}
