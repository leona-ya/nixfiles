{ ... }:
{
  imports = [
    ./wan.nix
    ./lan.nix
    ./dhcp.nix
    ./dns.nix
    ./firewall.nix
#    ./wireguard.nix
  ];

  boot.kernel.sysctl."net.ipv6.conf.all.forwarding" = true;
  boot.kernel.sysctl."net.ipv4.conf.all.forwarding" = true;
}
