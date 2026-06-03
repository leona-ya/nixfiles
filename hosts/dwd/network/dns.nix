{ pkgs, ... }:
{
  imports = [
    ../../../services/dns-kresd
  ];
  services.resolved.enable = false;
  services.knot-resolver.settings = {
    network.listen = [
      {
        interface = [
          "10.151.4.1"
          "fd8f:d15b:9f40:101::1"
        ];
      }
    ];
    views = [
      {
        subnets = [
          "10.151.0.0/16"
          "fd8f:d15b:9f40::/48"
        ];
        answer = "allow";
      }
    ];
  };
  networking.firewall.extraInputRules = ''
    ip saddr 10.151.0.0/16 tcp dport 53 accept
    ip saddr 10.151.0.0/16 udp dport 53 accept
    ip6 saddr fd8f:d15b:9f40::/48 tcp dport 53 accept
    ip6 saddr fd8f:d15b:9f40::/48 udp dport 53 accept
  '';
}
