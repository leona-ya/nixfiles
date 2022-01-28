{ helper, dns, config, lib, ... }:

{
  zone = with dns.lib.combinators; {
    TTL = 3600;
    SOA = ((ttl 600) {
      nameServer = "ns1.em0lar.dev.";
      adminEmail = "noc@em0lar.dev";
      serial = 2022012801;
      refresh = 3600;
      expire = 604800;
      minimum = 600;
    });

    NS = helper.ns;

    MX = helper.mail.mxSimple;
    DKIM = [{
      selector = "mail";
      p = "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAytgH0O0sve0H41q8fnmlGf07mx5x2La3gkXzhLt/Jh7ZOEILv8xRvUHMfHF9Sw4DF0PgXuW1e6XrO4nhp5kvHBtAR1iC0eI+sXMgWgh1fcqXfGpzVi4bcb/rnOTyd5LAx5LQLE+zTiaZltwWMPlxuIKWqm2eeFY+HnH7zfgIX5O6alAm7yDwWxidjxTJvNAbxetpplqDIr+Fx5nSx+k9/vX03q5VZzO32M5TbjXO1HFS1Kxtr3uLW7Cu24fywUadK7yXyMHKzpLqPs5MC1QtN9guNgkO6RPb0upeYl96e8EHGtNI8lYbT1iFVksTJmzpTxgZKTuC+6yYTNN0ndNMLwIDAQAB";
    }];
    DMARC = helper.mail.dmarc;
    TXT = [ helper.mail.spf ];

    CAA = helper.caa;

    A = helper.hosts.web.A;
    AAAA = helper.hosts.web.AAAA;

    subdomains = {
      www.CNAME = [ "foros.net.em0lar.dev." ];
      git.CNAME = [ "beryl.net.em0lar.dev." ];
      md.CNAME = [ "beryl.net.em0lar.dev." ];
    };
  };
}
