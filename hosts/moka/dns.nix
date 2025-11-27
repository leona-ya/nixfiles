{ pkgs, ... }: {
  services.resolved.enable = false;
  services.kresd = {
    enable = true;
    package = pkgs.knot-resolver.override { extraFeatures = true; };
    # Really prevent this server getting used for DDOS amplification.
    # We have two lines of defense here:
    #   - whitelist queries within kresd
    #   - firewall blocking all outside traffic to port 53
    extraConfig = ''
      modules.load('view')

      -- whitelist queries identified by subnet
      view:addr('127.0.0.0/8', policy.all(policy.PASS))
      view:addr('::1/128', policy.all(policy.PASS))
      view:addr('135.181.140.95/32', policy.all(policy.PASS))
      view:addr('95.217.67.8/29', policy.all(policy.PASS))
      view:addr('172.16.10.1/24', policy.all(policy.PASS))
      view:addr('2a01:4f9:3a:1448::/64', policy.all(policy.PASS))

      -- drop everything that hasn't matched
      view:addr('0.0.0.0/0', policy.all(policy.DROP))
      view:addr('::/0', policy.all(policy.DROP))
      cache.size = 150*MB

      modules.load('http')

      net.listen('127.0.0.1', 8453, { kind = 'webmgmt' })
      http.prometheus.namespace = 'kresd_'

      modules = {
        predict = {
          window = 15,
          period = 24*(60/15)
        }
      }
    '';
    listenPlain = [
      "127.0.0.1:53"
      "[::1]:53"
      "135.181.140.95:53"
      "172.16.10.1:53"
      "[2a01:4f9:3a:1448::]:53"
      "[2a01:4f9:3a:1448:4000::]:53"
    ];
  };

  networking.firewall.extraInputRules = ''
    iifname { br-vms, lo } tcp dport 53 accept
    iifname { br-vms, lo } udp dport 53 accept
  '';
}
