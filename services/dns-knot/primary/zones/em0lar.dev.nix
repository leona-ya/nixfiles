{
  hosthelper,
  helper,
  dns,
  config,
  lib,
  ...
}:

with dns.lib.combinators;
{
  zone = {
    TTL = 3600;
    SOA = (
      (ttl 300) {
        nameServer = "ns1.leona.is.";
        adminEmail = "noc@leona.is";
        serial = 2023082601;
        refresh = 300;
        expire = 604800;
        minimum = 300;
      }
    );

    NS = helper.ns;

    MX = helper.mail.mxSimple;
    TXT = [
      helper.mail.spf
      "google-site-verification=kqx2BRzGJW7_RwwzNhdeAkwEn-a9eiDti26Xcq0RbO8"
    ];
    DKIM = [
      {
        selector = "mail";
        p = "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAv0tgSLW0Z6cRachWzv4rSN2meAoDl/B8yaMNDwA5B+3wGWI5gVe2dxRog/ZYqEvXFJBUsOp5zm6nPesLe6P9f8okFaHOvSnh6Y88qnqoCqxB17Dvim2zoQ9002svT0TrASkGt9y0mDJJzeYOVJAs5oTXOMGwtRFZONKnLtFtaivkGWlSR1qc3Ei21VQkAMiyC22yPt8ZjA/QhVeGDPfooH8/uDa1si2ti4oVpqxBUQzzZu6qat2RwM00hMfjhkUmpd0EisJ2o/3LDa+UKcVToqPHiCLEI7NJiWoqm0VVinHbaOOqs/A84FiXc8jtlZLN6vcjFZp5/VpLZwquXWZSawIDAQAB";
      }
    ];
    DMARC = helper.mail.dmarc;

    CAA = helper.caa;

    A = helper.hosts.web.A;
    AAAA = helper.hosts.web.AAAA;

    subdomains = hosthelper.services.dns-int.g_dns_records // {
      "wg.net".CNAME = [ "haku.net.leona.is." ];

      mail.CNAME = [ "koyo.net.infinitespace.dev." ];
      autoconfig.CNAME = [ "koyo.net.infinitespace.dev." ];
      "wg-sternpunkt".CNAME = [ "wg.net.leona.is." ]; # backwards compatability

      "ca".MX = [ (mx.mx 10 "koyo.net.infinitespace.dev.") ];
      "ca".TXT = [ helper.mail.spf ];
      "ca".DKIM = [
        {
          selector = "mail";
          p = "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA2WJ46bl9UqBY9ZxqkVCBdSiysIJMUbWS3BK10Lupe4T5+jWAcdzJraznWeaVF/mR/9TyiB7lE79ZB6WxHxTwwJ5UZjURwImKAKqSGPXPACIj+LHyx5j2nHN4CawC6bkCmpGT99B7I/5bCelekoAHV9U/4pE2YEjgA0VxvlSKHB2Y7cPWL303DInYGaTrvMczuwLYoEwIiBirffYNqHyrOJE9A+ZQRdLjM8DFOxegAOV9mcHb3MwneJuu86Czz45UIrQ7AxkMUNKgHitqTSnXzLWd4BF6Kf3XUh/lED7WPdviBLJo/1H0Cgch8RRlinTeDVliHDQ6/zLWpk6+k3iKkQIDAQAB";
        }
      ];
    };
  };
}
