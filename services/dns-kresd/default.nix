{ config, pkgs, ... }: {
  services.resolved.enable = false;
  l.nftables.extraInput = ''
    ip saddr 10.151.0.0/16 tcp dport 53 accept
    ip saddr 10.151.0.0/16 udp dport 53 accept
    ip6 saddr fd8f:d15b:9f40::/48 tcp dport 53 accept
    ip6 saddr fd8f:d15b:9f40::/48 udp dport 53 accept
  '';
  services.kresd = {
    enable = true;
    package = pkgs.knot-resolver.override { extraFeatures = true; };
    extraConfig = ''
      modules.load('view')

      -- whitelist queries identified by subnet
      view:addr('127.0.0.0/8', policy.all(policy.PASS))
      view:addr('::1/128', policy.all(policy.PASS))
      view:addr('10.151.0.0/16', policy.all(policy.PASS))
      view:addr('fd8f:d15b:9f40::/48', policy.all(policy.PASS))

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
  };
}
