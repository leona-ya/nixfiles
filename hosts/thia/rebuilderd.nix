{ pkgs, ... }:
{
  services.rebuilderd = {
    enable = true;
    package = pkgs.rebuilderd.overrideAttrs (fA: {
      src = pkgs.fetchFromGitLab {
        domain = "forkspace.net";
        owner = "leona-bachelor-thesis/rebuilderd-tooling";
        repo = "rebuilderd";
        rev = "3e1389a21b09842b820f4d0f2d2895a65f5c1d9c";
        hash = "sha256-tUlGefed2MNpOR61c9+EmyC85zZmbHlL+BM1zvdRtxQ=";
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
