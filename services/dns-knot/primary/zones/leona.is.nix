{ hosthelper, helper, dns, config, lib, ... }:

with dns.lib.combinators;

let
haku_host = host "195.39.247.188" "2a0f:4ac0:0:1::d25";
naiad_host = host "37.120.184.164" "2a03:4000:f:85f::1";
kupe_host = host "195.39.247.146" "2a01:4f8:242:155f:1000::f28";
laurel_host = host "195.39.247.149" "2a01:4f8:242:155f:1000::b4d";
in {
  zone = {
    TTL = 600;
    SOA = ((ttl 600) {
      nameServer = "ns1.leona.is.";
      adminEmail = "noc@leona.is";
      serial = 2022071603;
      refresh = 300;
      expire = 604800;
      minimum = 300;
    });

    NS = helper.ns;

    MX = helper.mail.mxSimple;
    TXT = [
      helper.mail.spf
    ];
    DKIM = [{
      selector = "mail";
      p = "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAxAdCbH2V1TQgnscRit9ogxbPD3tibtgFzdW4EshD737hi7yV3g0njk/8P9UcNx0mqVwjDcBxENL1bd5MywHrRfBrkbaez2wEmZbcGzE5ljaEHk0QzwAvG+Yws4q32EHmLBmwRaT4+wSvXrp6F/FqJ4GDyWigaoEvrc+6tKgc7oAgi4k5VItv/AUJXXHsrWCd81CpcPMzEAbL460ISUmD0xRsIScvEsDCzRPAXi0smkaOxFt5oNQbTZOu22WgkyGuz7y0g/0dX7s/8ZD4J1LiAHJswnF3hq7jIWWAoRmAtKjyEFufghRfAeiZoi+gr1e1MzPKxJ4jJ+l2nA4rNkE+XQIDAQAB";
    }];

    DMARC = helper.mail.dmarc;

    CAA = helper.caa;

    A = helper.hosts.web.A;
    AAAA = helper.hosts.web.AAAA;


    subdomains = hosthelper.services.dns-int.g_dns_records // {
      "naiad.net" = naiad_host;
      "hack.net".AAAA = [ "2a01:4f8:242:155f:1000::fc5" ];
      "haku.net" = haku_host;
      "kupe.net" = kupe_host;
      "nyo.net" = host "136.243.42.251" "2a01:4f8:212:ad7::1";
      "nyan.net" = host "168.119.67.67" "2a01:4f8:242:155f::1";
      "foros.net" = host "195.39.247.144" "2a01:4f8:242:155f:1000::987";
      "beryl.net" = host "195.39.247.145" "2a01:4f8:242:155f:1000::b33";
      "ladon.net" = host "195.39.247.147" "2a01:4f8:242:155f:1000::1a2";
      "laurel.net" = laurel_host;
      "turingmachine.net" = host "195.39.247.148" "2a0f:4ac0:1e0:100::1";
      "*.turingmachine.net".CNAME = [ "turingmachine.net.leona.is." ];
      "wg.net".CNAME = [ "haku.net.leona.is." ];
      "haj-social".CNAME = [ "laurel.net.leona.is." ];

      "ns1" = kupe_host;
      "ns2" = haku_host;
      "ns3" = naiad_host;

      mail = kupe_host;
      autoconfig.CNAME = [ "kupe.net.em0lar.dev." ];
      "wg-sternpunkt".CNAME = [ "wg.net.leona.is." ]; # backwards compatability
      "encladus.lan.int.sig.de".CNAME = [ "encladus.lan." ]; # backwards compatability

      "ca".MX = [ (mx.mx 10 "kupe.net.em0lar.dev.") ];
      "ca".TXT = [ helper.mail.spf ];
      "ca".DKIM = [{
        selector = "mail";
        p = "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA2WJ46bl9UqBY9ZxqkVCBdSiysIJMUbWS3BK10Lupe4T5+jWAcdzJraznWeaVF/mR/9TyiB7lE79ZB6WxHxTwwJ5UZjURwImKAKqSGPXPACIj+LHyx5j2nHN4CawC6bkCmpGT99B7I/5bCelekoAHV9U/4pE2YEjgA0VxvlSKHB2Y7cPWL303DInYGaTrvMczuwLYoEwIiBirffYNqHyrOJE9A+ZQRdLjM8DFOxegAOV9mcHb3MwneJuu86Czz45UIrQ7AxkMUNKgHitqTSnXzLWd4BF6Kf3XUh/lED7WPdviBLJo/1H0Cgch8RRlinTeDVliHDQ6/zLWpk6+k3iKkQIDAQAB";
      }];

      www.CNAME = [ "foros.net.leona.is." ];
      auth.CNAME = [ "ladon.net.leona.is." ];
      alertmanager.CNAME = [ "naiad.net.leona.is." ];
      alertmanager-bot.CNAME = [ "naiad.net.leona.is." ];
      cloud.CNAME = [ "foros.net.leona.is." ];
      fin.CNAME = [ "foros.net.leona.is." ];
      "dataimporter.fin".CNAME = [ "foros.net.leona.is." ];
      git.CNAME = [ "beryl.net.leona.is." ];
      grafana.CNAME = [ "naiad.net.leona.is." ];
      grocy.CNAME = [ "foros.net.leona.is." ];
      inv.CNAME = [ "foros.net.leona.is." ];
      "api.grocy".CNAME = [ "foros.net.leona.is." ];
      matrix.CNAME = [ "laurel.net.leona.is." ];
      md.CNAME = [ "laurel.net.leona.is." ];
      paperless.CNAME = [ "laurel.net.leona.is." ];
      prometheus.CNAME = [ "naiad.net.leona.is." ];
      sso.CNAME = [ "ladon.net.leona.is." ];
      "hydra.sso".CNAME = [ "ladon.net.leona.is." ];
      todo.CNAME = [ "laurel.net.leona.is." ];
      pass.CNAME = [ "laurel.net.leona.is." ];
      pl.CNAME = [ "laurel.net.leona.is." ];
    };
  };
}
