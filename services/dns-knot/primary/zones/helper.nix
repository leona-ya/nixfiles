{ dns, ... }:

with dns.lib.combinators;

{
  ns = [ "ns1.leona.is." "ns2.leona.is." "ns3.leona.is." ];
  mail = rec {
    mxSimple = [
      (mx.mx 10 "kupe.net.em0lar.dev.")
    ];
    spf = (with dns.lib.combinators.spf; soft [
      "a"
      "mx"
    ]);
    dmarc = [{
      p = "quarantine";
      sp = "quarantine";
      rua = "mailto:noc@leona.is";
    }];
  };
  caa = letsEncrypt "noc@leona.is";  # Common template combinators included
  hosts = {
    web = {
     A = [ "195.39.247.144" ];
     AAAA = [ "2a01:4f8:242:155f:1000::987" ];
    };
  };
}
