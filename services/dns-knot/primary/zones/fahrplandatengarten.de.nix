{
  dns,
  ...
}:
with dns.lib.combinators;
{
  zone = {
    TTL = 3600;
    SOA = (
      (ttl 3600) {
        nameServer = "ns1.leona.is.";
        adminEmail = "noc@fahrplandatengarten.de";
        serial = 2026050501; # format: YYYYMMDDHH##
        refresh = 3600;
        expire = 604800;
        minimum = 300;
      }
    );

    NS = [
      "ns1.leona.is."
      "ns2.leona.is."
      "ns3.leona.is."
    ];

    MX = [ (mx.mx 10 "mail.leona.is.") ];
    TXT = [
      (
        with dns.lib.combinators.spf;
        soft [
          "a"
          "mx"
        ]
      )
    ];

    DMARC = [
      {
        p = "quarantine";
        sp = "quarantine";
        rua = "mailto:noc@fahrplandatengarten.de";
      }
    ];

    CAA = letsEncrypt "noc@fahrplandatengarten.de";

    # currently broken, but keeping as an archive
    A = [ "128.140.93.148" ];
    AAAA = [ "2a01:4f8:c012:5ab9::1" ];

    subdomains = {
      "martian.infra" = host "128.140.93.148" "2a01:4f8:c012:5ab9::1";
      "fdg-dev-ember.infra".AAAA = [ "2a0e:8f02:f022:fe00::140" ];
      "mars.het.nue.de.vpn".AAAA = [ "fd59:974e:6ee8::1" ];
      "jupiter.int.goe.de.vpn".AAAA = [ "fd59:974e:6ee8:10::1:1" ];
      "merkur.vpn".AAAA = [ "fd59:974e:6ee8:10::2:1" ];

      "ns1" = host "128.140.93.148" "2a01:4f8:c012:5ab9::1";

      www.CNAME = [ "martian.infra.fahrplandatengarten.de." ];
      "mars.het.nue.de".CNAME = [ "martian.infra.fahrplandatengarten.de." ];
      pyhafas.CNAME = [ "martian.infra.fahrplandatengarten.de." ];
    };
    #// hosthelper.services.dns-int.g_dns_records;
  };
}
