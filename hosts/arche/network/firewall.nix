{ lib, ... }:
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
        allowedUDPPorts = [
          53
          5353 # mDNS
        ];
        allowedTCPPorts = [ 53 ];
      };
      "br-iot" = {
        allowedUDPPorts = [
          53
          5353 # mDNS
        ];
        allowedTCPPorts = [ 53 ];
      };
    };
    extraForwardRules = ''
      ct state invalid drop
      ct state established,related accept

      ip6 daddr 2001:4090:e013:2d00:2efd:a1ff:fee1:beac tcp dport { 22, 53, 80, 443 } ct state new accept
      ip6 daddr 2001:4090:e013:2d00:2efd:a1ff:fee1:beac udp dport { 53, 80, 443 } ct state new accept
    ''
    + (lib.concatStringsSep "\n" (
      lib.map (ifaces: "iifname ${ifaces."in"} oifname ${ifaces."out"} ct state new accept") (
        (lib.crossLists
          (x: y: {
            "in" = x;
            "out" = y;
          })
          [
            [
              "br-clients"
              "br-infra"
              "br-iot"
            ]
            [ "ppp-wan" ]
          ]
        )
        ++ [
          {
            "in" = "br-clients";
            "out" = "br-infra";
          }
          {
            "in" = "br-clients";
            "out" = "br-iot";
          }
          {
            "in" = "br-iot";
            "out" = "br-clients";
          }
        ]
      )
    ));
  };
  networking.nat = {
    enable = true;
    internalInterfaces = [
      "br-clients"
      "br-infra"
      "br-iot"
    ];
    externalInterface = "ppp-wan";
  };
}
