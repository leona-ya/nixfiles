{ helper, dns, config, lib, ... }:

{
  zone = with dns.lib.combinators; {
    TTL = 3600;
    SOA = ((ttl 600) {
      nameServer = "ns1.em0lar.dev.";
      adminEmail = "noc@labcode.de";
      serial = 2021040410;
      refresh = 3600;
      expire = 604800;
      minimum = 600;
    });

    NS = helper.ns;

    MX = helper.mail.mxWithFallback;

    TXT = [ helper.mail.spf ];
    CAA = helper.caa;

    A = helper.hosts.web.A;
    AAAA = helper.hosts.web.AAAA;

    subdomains = {
      "dkim._domainkey".TXT = [
        (txt ''v=DKIM1;k=rsa;t=s;s=email;p=" "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAo0hycCrpWmzBIvErNUk10dgm/u6x+755HDRgqce/EB8CutPTgN+zUB17I3mPTGBcEqfn4HkIE21NXhdefbaJ9c2RM9xgC+uyDnz6pyjjEwNAdoGs5rIjCGt7ZfxiWkN85b4OPZa34xa120FmB9y2ZFaWd+4f0VFx3qOGAocceh6uvVZGO9QTjkqck1DgzXl/BLvLt+7vAt4jSGR" "/IeChy5te4e/p8G7slKVmEWgNkwS/tmwa88lEayK6w1zTW0cmLoaefQPJnuYZi9OedF8jYiFVFBDd5p81l2/qombtX6+5EZ9JCn9d0kmMQDQl+vzuaRSO70dSOEzQkEAXvDeqaQIDAQAB'')
      ];
      nl.MX = helper.mail.mxSimple;
      nl.TXT = [ helper.mail.spf ];
      services.MX = helper.mail.mxWithFallback;
      services.TXT = [ helper.mail.spf ];
      "dkim._domainkey.services".TXT = [
        (txt ''v=DKIM1;k=rsa;t=s;s=email;p=" "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA3B7IXz4nSFvw3pS/7GZwgHiMtAeIwzjWhZXiYsh9ZdUmHwlaW510Hjv+K2ET1H6w8Fv++OITvXbzEWEVRpXFWsvuaGYrzWD7l30V05V+o0HQDtyKN6TigX6Z+v0G7ucljY06h9u0LXYArPkXya1WpFvrIk06M8hqtk7eT19TqqVSZ7SVOba6bBV46Lm3iwIM9BXPBvclCwEvR1" "/tXGxRfp74Wor3wvWNjvsWwaXMRep352WOjuZyj05GfV2XVZ9A7tcpjhcKD27pzZ0Tv+npou9InFgM4yRW/1QazbCpQ0qrT8kuT0mo5Y9Oh6+T0HaR/Bpx4w6jx0z1AlJ6zqKchwIDAQAB'')
      ];

      www.CNAME = [ "foros.int.sig.de.em0lar.dev." ];
      cloud.CNAME = [ "foros.int.sig.de.em0lar.dev." ];
    };
  };
}
