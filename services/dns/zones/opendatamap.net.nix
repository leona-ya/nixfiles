{ helper, dns, config, lib, ... }:

{
  zone = with dns.lib.combinators; {
    TTL = 3600;
    SOA = ((ttl 600) {
      nameServer = "ns1.em0lar.dev.";
      adminEmail = "noc@labcode.de";
      serial = 2021040302;
      refresh = 3600;
      expire = 604800;
      minimum = 600;
    });

    NS = [ "ns1.em0lar.dev." "ns2.em0lar.dev." "ns3.em0lar.dev." ];

    A = helper.hosts.web.A;
    AAAA = helper.hosts.web.AAAA;

    MX = helper.mail.mxSimple;
    TXT = [
      helper.mail.spf
    ];
    CAA = helper.caa;
    subdomains = {
      www.CNAME = [ "foros.int.sig.de.em0lar.dev." ];
      grafana.CNAME = [ "foros.int.sig.de.em0lar.dev." ];
      node-red.CNAME = [ "foros.int.sig.de.em0lar.dev." ];
      rhein-sieg.CNAME = [ "foros.int.sig.de.em0lar.dev." ];
    };
  };
}
