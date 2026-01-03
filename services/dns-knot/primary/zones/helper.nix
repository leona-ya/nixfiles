{ dns, ... }:

with dns.lib.combinators;

{
  ns = map (ttl 86400) [
    (ns "ns1.leona.is.")
    (ns "ns2.leona.is.")
    (ns "ns3.leona.is.")
  ];
  mail = rec {
    mxSimple = [
      (mx.mx 10 "kupe.net.leona.is.")
    ];
    spf = (
      with dns.lib.combinators.spf;
      strict [
        "mx"
      ]
    );
    dmarc = [
      {
        p = "quarantine";
        sp = "quarantine";
        rua = "mailto:noc@leona.is";
        adkim = "relaxed";
        aspf = "relaxed";
      }
    ];
  };
  caa = letsEncrypt "noc@leona.is"; # Common template combinators included
  hosts = {
    web = {
      A = [ "95.217.67.8" ];
      AAAA = [ "2a01:4f9:3a:1448:4000:b11::" ];
    };
  };
}
