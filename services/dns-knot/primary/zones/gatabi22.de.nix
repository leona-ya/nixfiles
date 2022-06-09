{ helper, dns, config, lib, ... }:

{
  zone = with dns.lib.combinators; {
    TTL = 3600;
    SOA = ((ttl 600) {
      nameServer = "ns1.leona.is.";
      adminEmail = "noc@leona.is";
      serial = 2022060601;
      refresh = 3600;
      expire = 604800;
      minimum = 600;
    });

    NS = helper.ns;

    MX = helper.mail.mxSimple;
    DMARC = helper.mail.dmarc;
    TXT = [ helper.mail.spf ];
    DKIM = [{
      selector = "mail";
      p = "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAn6s2jmoYrLKEn5TH2G6ORNAPzz35f9b40y/ity5A1va+FiCxNaEHj0Gx8o3iV75V4UY9xbXZyt8GaNacW8Jv02FT+5+5MQz7ov6itsj77XtCaN2A5WjjvlgZ65/i9BiYpu+kBliVTKiyHMejICb0EzleOVx2lO7fke3hly1X+t4gm7oJf0a3MJglGH8gilOV+al9wBRCzSdGr+N74vYYwDV42RhJK1EITxdmuRnCwu22c7ieyDlhWFeiIbmatKjBHx++Z1ez9idA/lsh4DDonZjuSJZw04hLaxn2QRQq2WbvDxK6lDvhs5IfKqkBqC1T6z8luPwPmiVkYsr65PKlbQIDAQAB";
    }];

    CAA = helper.caa;

    A = helper.hosts.web.A;
    AAAA = helper.hosts.web.AAAA;

    subdomains = {
      www.CNAME = [ "foros.net.leona.is." ];
    };
  };
}
