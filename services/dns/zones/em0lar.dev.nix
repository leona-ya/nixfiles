{ helper, dns, config, lib, ... }:

with dns.lib.combinators;

let
myron_host = host "95.217.178.242" "2a01:4f9:c010:beb5::1";
haku_host = host "195.39.247.188" "2a0f:4ac0:0:1::d25";
rechaku_host = host "49.12.7.88" "2a01:4f8:c17:235a::1";
naiad_host = host "37.120.184.164" "2a03:4000:f:85f::1";
in {
  zone = {
    TTL = 3600;
    SOA = ((ttl 600) {
      nameServer = "ns1.em0lar.dev.";
      adminEmail = "noc@labcode.de";
      serial = 2021052801;
      refresh = 3600;
      expire = 604800;
      minimum = 600;
    });

    NS = helper.ns;

    MX = helper.mail.mxSimple;
    TXT = [
      helper.mail.spf
      "google-site-verification=kqx2BRzGJW7_RwwzNhdeAkwEn-a9eiDti26Xcq0RbO8"
    ];
    DKIM = [{
      selector = "mail";
      p = "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAv0tgSLW0Z6cRachWzv4rSN2meAoDl/B8yaMNDwA5B+3wGWI5gVe2dxRog/ZYqEvXFJBUsOp5zm6nPesLe6P9f8okFaHOvSnh6Y88qnqoCqxB17Dvim2zoQ9002svT0TrASkGt9y0mDJJzeYOVJAs5oTXOMGwtRFZONKnLtFtaivkGWlSR1qc3Ei21VQkAMiyC22yPt8ZjA/QhVeGDPfooH8/uDa1si2ti4oVpqxBUQzzZu6qat2RwM00hMfjhkUmpd0EisJ2o/3LDa+UKcVToqPHiCLEI7NJiWoqm0VVinHbaOOqs/A84FiXc8jtlZLN6vcjFZp5/VpLZwquXWZSawIDAQAB";
    }];
    DMARC = helper.mail.dmarc;

    CAA = helper.caa;

    A = helper.hosts.web.A;
    AAAA = helper.hosts.web.AAAA;

    subdomains = {
      "cetus.het.hel.fi" = host "95.216.160.224" "2a01:4f9:c010:1dcf::1";
      "janus.ion.rhr.de" = host "93.90.205.65" "2001:8d8:1800:30a::1";
      "myron.het.hel.fi" = myron_host;
      "naiad.ncp.nue.de" = naiad_host;
      "haku.pbb.wob.de".CNAME = [ "haku.pbb.dus.de.em0lar.dev." ];
      "haku.pbb.dus.de" = haku_host;
      "rechaku.het.fks.de" = rechaku_host;
      #"foros.int.sig.de" = host "195.39.247.144" "2a0f:4ac0:1e0:100::1";
      #"beryl.int.sig.de" = host "195.39.247.145" "2a0f:4ac0:1e0:101::1";
      "foros.int.sig.de" = host "195.39.247.144" "2a01:4f8:c17:235a:1000::2";
      "beryl.int.sig.de" = host "195.39.247.145" "2a01:4f8:c17:235a:1000::3";

      "ns1" = myron_host;
      "ns2" = rechaku_host;
      "ns3" = naiad_host;

      mail = myron_host;
      autoconfig.CNAME = [ "myron.het.hel.fi.em0lar.dev." ];
      backupmx.CNAME = [ "cetus.het.hel.fi.em0lar.dev." ];
      "wg-sternpunkt".CNAME = [ "haku.pbb.dus.de.em0lar.dev." ];

      "ca".MX = [ (mx.mx 10 "myron.het.hel.fi.em0lar.dev.") ];
      "ca".TXT = [ helper.mail.spf ];
      "ca".DKIM = [{
        selector = "mail";
        p = "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA2WJ46bl9UqBY9ZxqkVCBdSiysIJMUbWS3BK10Lupe4T5+jWAcdzJraznWeaVF/mR/9TyiB7lE79ZB6WxHxTwwJ5UZjURwImKAKqSGPXPACIj+LHyx5j2nHN4CawC6bkCmpGT99B7I/5bCelekoAHV9U/4pE2YEjgA0VxvlSKHB2Y7cPWL303DInYGaTrvMczuwLYoEwIiBirffYNqHyrOJE9A+ZQRdLjM8DFOxegAOV9mcHb3MwneJuu86Czz45UIrQ7AxkMUNKgHitqTSnXzLWd4BF6Kf3XUh/lED7WPdviBLJo/1H0Cgch8RRlinTeDVliHDQ6/zLWpk6+k3iKkQIDAQAB";
      }];

      www.CNAME = [ "foros.int.sig.de.em0lar.dev." ];
      auth.CNAME = [ "foros.int.sig.de.em0lar.dev." ];
      alertmanager.CNAME = [ "naiad.ncp.nue.de.em0lar.dev." ];
      alertmanager-bot.CNAME = [ "naiad.ncp.nue.de.em0lar.dev." ];
      git.CNAME = [ "beryl.int.sig.de.em0lar.dev." ];
      grafana.CNAME = [ "naiad.ncp.nue.de.em0lar.dev." ];
      md.CNAME = [ "beryl.int.sig.de.em0lar.dev." ];
      prometheus.CNAME = [ "naiad.ncp.nue.de.em0lar.dev." ];
      stun.CNAME = [ "cetus.het.hel.fi.em0lar.dev." ];
      turn.CNAME = [ "cetus.het.hel.fi.em0lar.dev." ];
      webmail.CNAME = [ "foros.int.sig.de.em0lar.dev." ];
      wifi.CNAME = [ "foros.int.sig.de.em0lar.dev." ];
    };
  };
}
