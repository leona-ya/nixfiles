{ helper, dns, config, lib, ... }:

{
  zone = with dns.lib.combinators; {
    TTL = 3600;
    SOA = ((ttl 600) {
      nameServer = "ns1.em0lar.dev.";
      adminEmail = "noc@em0lar.dev";
      serial = 2021072402;
      refresh = 3600;
      expire = 604800;
      minimum = 600;
    });

    NS = helper.ns;

    A = helper.hosts.web.A;
    AAAA = helper.hosts.web.AAAA;

    MX = helper.mail.mxSimple;
    TXT = [
      helper.mail.spf
    ];
    DMARC = helper.mail.dmarc;

    CAA = helper.caa;
    subdomains = {
      www.CNAME = [ "foros.net.em0lar.dev." ];
      "*".A = [ "162.55.82.116" ];
    };
  };
}
