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
          "10.20.0.1"
          "fd14:65c0:ffee:0::1"
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
  };
}
