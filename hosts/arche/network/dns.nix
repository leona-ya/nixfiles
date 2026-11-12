{ pkgs, ... }:
{
  imports = [
    ../../../services/dns-kresd
  ];
  services.resolved.enable = false;
  services.knot-resolver.settings = {
    logging = {
      level = "debug";
    };
    network.listen = [
      {
        interface = [
          "10.20.0.1"
          "10.20.10.1"
          "10.20.20.1"
          "fd14:65c0:ffee::1"
          #"fd14:65c0:ffee:10::1"
          "fd14:65c0:ffee:20::1"
        ];
      }
    ];
    views = [
      {
        subnets = [
          "10.20.0.0/16"
          "fd14:65c0:ffee::/48"
        ];
        answer = "allow";
      }
    ];
    forward = [
      {
        subtree = "global.fastly.net";
        servers = [
          {
            address = [
              "2001:4860:4860::8888"
              "2001:4860:4860::8844"
            ];
            transport = "tls";
            hostname = "dns.google";
          }
        ];
        # Fastly has no DNSSEC :<
        options.dnssec = false;
      }
    ];
  };
}
