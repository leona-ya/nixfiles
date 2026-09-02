{ ... }:
{
  # For now check every package. This can be optimized in the future to only affect packages outgoing via PPPoE
  networking.nftables.ruleset =
    let
      mtuFix = ''
        meta nfproto ipv6 tcp flags syn tcp option maxseg size 1305-65535 tcp option maxseg size set 1304
        meta nfproto ipv4 tcp flags syn tcp option maxseg size 1325-65535 tcp option maxseg size set 1324
      '';
    in
    ''
      table inet mtu-fix {
        chain input {
          type filter hook input priority filter; policy accept;
          ${mtuFix}
        }
        chain output {
          type filter hook output priority filter; policy accept;
          ${mtuFix}
        }
        chain forward {
          type filter hook forward priority filter; policy accept;
          ${mtuFix}
        }
      }
    '';
  networking.firewall = {
    interfaces = {
      "br-clients" = {
        allowedUDPPorts = [ 53 ];
        allowedTCPPorts = [ 53 ];
      };
    };
    extraForwardRules = ''
      ct state invalid drop
      ct state established,related accept

      iifname br-clients oifname ppp-wan ct state new accept

      ip6 daddr 2001:4090:e013:2d00:2efd:a1ff:fee1:beac tcp dport { 53, 80, 443 } ct state new accept
      ip6 daddr 2001:4090:e013:2d00:2efd:a1ff:fee1:beac udp dport { 53, 80, 443 } ct state new accept
    '';
  };
  networking.nat = {
    enable = true;
    internalInterfaces = [ "br-clients" ];
    externalInterface = "ppp-wan";
  };
}
