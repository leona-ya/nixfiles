{ helper, dns, config, lib, ... }:

{
  zone = with dns.lib.combinators; {
    TTL = 3600;
    SOA = ((ttl 600) {
      nameServer = "ns1.leona.is.";
      adminEmail = "noc@leona.is";
      serial = 2022032201;
      refresh = 3600;
      expire = 604800;
      minimum = 600;
    });

    NS = helper.ns;

    MX = helper.mail.mxSimple;

    TXT = [
      helper.mail.spf
      "google-site-verification=T-Sfq35kze0or8AKMVb9v_nPgAyiLWBE3fnR0ynUw48"
    ];
    DKIM = [{
      selector = "mail";
      p = "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEArrl2qY4nBdgLQnLvR1S6KUM7PU4nqGwZUTvQ+cSgGxUMnVCo8KQ9P/h9EFOxyW6hsvQhU40X9r1JyYocBpZDsmtlDrxV17+VZQSN119eBLcaqHFqxJlXayQX7oDMBjokFF+IzoVSi5s461L1iAzDj7EfV6PPNhKmQvSuRlQbvGCrlzCXEv/HlzSF7/BBohorOfWmSJyDt5SXZxx5VOBqEQON1WZhwAtrMDfrvS6TaHlU/v0S49VZrQrFulmxg9NOX6TNXyfoim4s66h4lR5a2JyvxmIH8AWMZdVQ3bey25jDWtPyE7SuLm1w0U4YZcMZVLNGTJo5D1c03QJRjAyF8QIDAQAB";
    }];
    DMARC = helper.mail.dmarc;

    CAA = helper.caa;

    A = helper.hosts.web.A;
    AAAA = helper.hosts.web.AAAA;

    subdomains = {
      ca.MX = helper.mail.mxSimple;
      ca.TXT = [ helper.mail.spf ];
      ca.DKIM = [{
        selector = "mail";
        p = "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAzVQD7sCSZNuzYN8Lxzu8Ynv19Z0E3dtu0AufKrQg7XNX5caQ+m32um1KfzIN/XTe4PTWCLb99M+6ROfl3DS6JxEP31JNv9CHesnprrMzlODnMdRsBw5PP0UT9oebmdVH2VJeNtYlt34Sof3bUcNEqG9ocW4p3WEEY1Eg8X+CgZc2aecUsEYWGi9Ric85a0Rza66v47UZSe/Rw+NTAkzsJUGCuaw+vR2sGTnPa1je3KEsP3eYwDlhm2qdRoFXw5drwoF7hXiucPXNrNm1VWHwOjDwMUHiI+yUt7GAbJ2dq081qtkcnoyQCOVyPzxSSMcIfpKqu1swpQlSlkYr7R/MHQIDAQAB";
      }];

      www.CNAME = [ "kupe.net.em0lar.dev." ];
      auth.CNAME = [ "ladon.net.leona.is." ];
      element.CNAME = [ "foros.net.leona.is." ];
      git.CNAME = [ "beryl.net.leona.is." ];
      md.CNAME = [ "beryl.net.leona.is." ];
      tell.CNAME = [ "foros.net.leona.is." ];
    };
  };
}
