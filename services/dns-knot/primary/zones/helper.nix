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
    spf = (with dns.lib.combinators.spf; strict [
      "a"
      "aaaa"
      "mx"
    ]);
    dmarc = [{
      p = "quarantine";
      sp = "quarantine";
      rua = "mailto:noc@leona.is";
      adkim = "relaxed";
      aspf = "relaxed";
    }];
  };
  caa = letsEncrypt "noc@leona.is"; # Common template combinators included
  hosts = {
    web = {
      A = [ "168.119.100.247" ];
      AAAA = [ "2a01:4f8:c010:1098::1" ];
    };
  };
}
