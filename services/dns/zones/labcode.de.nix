{ helper, dns, config, lib, ... }:

{
  zone = with dns.lib.combinators; {
    TTL = 3600;
    SOA = ((ttl 600) {
      nameServer = "ns1.em0lar.dev.";
      adminEmail = "noc@labcode.de";
      serial = 2021040901;
      refresh = 3600;
      expire = 604800;
      minimum = 600;
    });

    NS = helper.ns;

    MX = helper.mail.mxWithFallback;
    DKIM = [{
      selector = "dkim";
      t = [ "s" ];
      s = [ "email" ];
      p = "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAyi4rajvnJrJtJDH7kaajbW6SwlN8GBwVsEjeJ54jQeKPOZxk3h8vDwvUbr9aKcZl3FHMMnTeGNEEvOxyTRoSpCcmIi+pcEHeZmtJ75bhBsodgrWIj6hl3i+54DJ2MWkkMnZuLiL8a/2EUjeeyUtn2bFqg3s7Mw88StTh8XQZyGUjWeJea3IauKpEgRE30824p26xk+Ljfl5aXh9osKcY2tIPZRUqX6LEcyjVC3FnyZSC8x+okbTsYLdAWgQoujldnYYPNKKQ2Ql+Ze5dgjJMLtoWvWY0yFtiQBDVATfM+v3BdBF97l7cI/i53aKO09OnF6K306+GMjtQePnWBJqjmwIDAQAB";
    }];
    TXT = [ helper.mail.spf ];
    CAA = helper.caa;

    A = helper.hosts.web.A;
    AAAA = helper.hosts.web.AAAA;

    subdomains = {
      # server
      "cetus.het.hel.fi" = host "95.216.160.224" "2a01:4f9:c010:1dcf::1";
      "janus.ion.rhr.de" = host "93.90.205.65" "2001:8d8:1800:30a::1";
      "dione.int.sig.de".CNAME = [ "foros.int.sig.de.em0lar.dev." ]; # backwards compatibility
      "nas.home".CNAME = [ "encladus.lan.int.sig.de.em0lar.dev." ]; # backwards compatibility

      mail.CNAME = [ "cetus.het.hel.fi.em0lar.dev." ];
      backupmx.CNAME = [ "cetus.het.hel.fi.em0lar.dev." ];
      ns = host "95.216.160.224" "2a01:4f9:c010:1dcf::1"; # cetus

      www.CNAME = [ "foros.int.sig.de.em0lar.dev." ];
      auth.CNAME = [ "foros.int.sig.de.em0lar.dev." ];
      cdn.CNAME = [ "foros.int.sig.de.em0lar.dev." ];
      git.CNAME = [ "beryl.int.sig.de.em0lar.dev." ];
      matrix.CNAME = [ "beryl.int.sig.de.em0lar.dev." ];
      mautrix-telegram.CNAME = [ "beryl.int.sig.de.em0lar.dev." ];
      md.CNAME = [ "beryl.int.sig.de.em0lar.dev." ];
      static.CNAME = [ "foros.int.sig.de.em0lar.dev." ];
      stun.CNAME = [ "cetus.het.hel.fi.em0lar.dev." ];
      turn.CNAME = [ "cetus.het.hel.fi.em0lar.dev." ];
      wifi.CNAME = [ "foros.int.sig.de.em0lar.dev." ];
    };
  };
}
