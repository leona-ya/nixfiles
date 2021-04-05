{ dns, ... }:

with dns.lib.combinators;

let
  mailserver = "cetus.het.hel.fi.labcode.de.";
in {
  ns = [ "ns1.em0lar.dev." "ns2.em0lar.dev." "ns3.em0lar.dev." ];
  mail = rec {
    mxSimple = [
      (mx.mx 10 mailserver)
    ];
    mxWithFallback = mxSimple ++ [
      (mx.mx 100 "backupmx.dont-break.it.")
    ];
    spf = (with dns.lib.combinators.spf; soft [
      "a"
      "mx"
    ]);
  };
  caa = letsEncrypt "noc@em0lar.dev";  # Common template combinators included
  hosts = {
    web = {
     A = [ "195.39.247.144" ];
     AAAA = [ "2a0f:4ac0:1e0:100::1" ];
    };
  };
}
