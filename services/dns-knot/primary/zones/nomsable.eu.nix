{
  helper,
  dns,
  config,
  lib,
  ...
}:

{
  zone = with dns.lib.combinators; {
    TTL = 3600;
    SOA = (
      (ttl 600) {
        nameServer = "ns1.leona.is.";
        adminEmail = "noc@leona.is";
        serial = 0;
        refresh = 3600;
        expire = 604800;
        minimum = 600;
      }
    );

    NS = helper.ns;

    TXT = [
      helper.mail.spf
    ];
    DMARC = helper.mail.dmarc;

    CAA = helper.caa;

    A = helper.hosts.web.A;
    AAAA = [ "2a01:4f9:3a:1448:4000:10::" ];
  };
}
