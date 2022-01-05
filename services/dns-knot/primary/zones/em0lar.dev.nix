{ hosthelper, helper, dns, config, lib, ... }:

with dns.lib.combinators;

let
haku_host = host "195.39.247.188" "2a0f:4ac0:0:1::d25";
naiad_host = host "37.120.184.164" "2a03:4000:f:85f::1";
kupe_host = host "195.39.247.146" "2a01:4f8:212:ad7:1000::f28";
in {
  zone = {
    TTL = 600;
    SOA = ((ttl 300) {
      nameServer = "ns1.em0lar.dev.";
      adminEmail = "noc@em0lar.dev";
      serial = 2021122902;
      refresh = 300;
      expire = 604800;
      minimum = 300;
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

    subdomains = hosthelper.services.dns-int.g_dns_records // {
      "naiad.net" = naiad_host;
      "hack.net".AAAA = [ "2a01:4f8:212:ad7:1000::fc5" ];
      "haku.net" = haku_host;
      "kupe.net" = kupe_host;
      "nyo.net" = host "136.243.42.251" "2a01:4f8:212:ad7::1";
      "foros.net" = host "195.39.247.144" "2a01:4f8:212:ad7:1000::987";
      "beryl.net" = host "195.39.247.145" "2a01:4f8:212:ad7:1000::b33";
      "ladon.net" = host "195.39.247.147" "2a01:4f8:212:ad7:1000::1a2";
      "adonis.net" = host "130.61.64.61" "2603:c020:8004:50e0:4cb7:23e8:1668:f629";
      "wg.net".CNAME = [ "haku.net.em0lar.dev." ];

      "ns1" = kupe_host;
      "ns2" = haku_host;
      "ns3" = naiad_host;

      mail = kupe_host;
      autoconfig.CNAME = [ "kupe.net.em0lar.dev." ];
      "wg-sternpunkt".CNAME = [ "wg.net.em0lar.dev." ]; # backwards compatability
      "encladus.lan.int.sig.de".CNAME = [ "encladus.lan." ]; # backwards compatability

      "ca".MX = [ (mx.mx 10 "kupe.net.em0lar.dev.") ];
      "ca".TXT = [ helper.mail.spf ];
      "ca".DKIM = [{
        selector = "mail";
        p = "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA2WJ46bl9UqBY9ZxqkVCBdSiysIJMUbWS3BK10Lupe4T5+jWAcdzJraznWeaVF/mR/9TyiB7lE79ZB6WxHxTwwJ5UZjURwImKAKqSGPXPACIj+LHyx5j2nHN4CawC6bkCmpGT99B7I/5bCelekoAHV9U/4pE2YEjgA0VxvlSKHB2Y7cPWL303DInYGaTrvMczuwLYoEwIiBirffYNqHyrOJE9A+ZQRdLjM8DFOxegAOV9mcHb3MwneJuu86Czz45UIrQ7AxkMUNKgHitqTSnXzLWd4BF6Kf3XUh/lED7WPdviBLJo/1H0Cgch8RRlinTeDVliHDQ6/zLWpk6+k3iKkQIDAQAB";
      }];

      www.CNAME = [ "foros.net.em0lar.dev." ];
      auth.CNAME = [ "ladon.net.em0lar.dev." ];
      alertmanager.CNAME = [ "naiad.net.em0lar.dev." ];
      alertmanager-bot.CNAME = [ "naiad.net.em0lar.dev." ];
      convos.CNAME = [ "kupe.net.em0lar.dev." ];
      git.CNAME = [ "beryl.net.em0lar.dev." ];
      grafana.CNAME = [ "naiad.net.em0lar.dev." ];
      md.CNAME = [ "beryl.net.em0lar.dev." ];
      paperless.CNAME = [ "beryl.net.em0lar.dev." ];
      prometheus.CNAME = [ "naiad.net.em0lar.dev." ];
      sso.CNAME = [ "ladon.net.em0lar.dev." ];
      "hydra.sso".CNAME = [ "ladon.net.em0lar.dev." ];
      todo.CNAME = [ "beryl.net.em0lar.dev." ];
      webmail.CNAME = [ "foros.net.em0lar.dev." ];
      wifi.CNAME = [ "foros.net.em0lar.dev." ];
    };
  };
}
