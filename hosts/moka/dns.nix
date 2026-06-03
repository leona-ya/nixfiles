{ ... }:
{
  imports = [
    ../../services/dns-kresd
  ];
  services.knot-resolver.settings = {
    network.listen = [
      {
        interface = [
          "135.181.140.95"
          "172.16.10.1"
          "2a01:4f9:3a:1448::"
          "2a01:4f9:3a:1448:4000::"
        ];
      }
    ];
    views = [
      {
        subnets = [
          "135.181.140.95/32"
          "95.217.67.8/29"
          "172.16.10.0/24"
          "2a01:4f9:3a:1448::/64"
        ];
        answer = "allow";
      }
    ];
  };

  networking.firewall.extraInputRules = ''
    iifname { br-vms, lo } tcp dport 53 accept
    iifname { br-vms, lo } udp dport 53 accept
  '';
}
