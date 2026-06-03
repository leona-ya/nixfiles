{ config, pkgs, ... }:
{
  services.resolved.enable = false;
  services.knot-resolver = {
    enable = true;
    managerPackage = pkgs.knot-resolver-manager_6.override { extraFeatures = true; };
    # Really prevent this server getting used for DDOS amplification.
    # We have two lines of defense here:
    #   - whitelist queries within kresd
    #   - firewall blocking all outside traffic to port 53
    settings = {
      # will be extended by the host configs
      network.listen = [
        { interface = "lo"; }
      ];
      views = [
        {
          subnets = [
            "0.0.0.0/0"
            "::/0"
          ];
          answer = "refused";
        }
        {
          subnets = [
            "127.0.0.0/8"
            "::1"
          ];
          answer = "allow";
        }
      ];
      cache.prefetch.prediction = {
        enable = true;
      };
    };
  };
}
