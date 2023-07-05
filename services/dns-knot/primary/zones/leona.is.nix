{ hosthelper, helper, dns, config, lib, ... }:

with dns.lib.combinators;

let
haku_host = host "195.39.247.188" "2a0f:4ac0:0:1::d25";
naiad_host = host "37.120.184.164" "2a03:4000:f:85f::1";
kupe_host = host "159.69.17.61" "2a01:4f8:1c1c:f0b::1";
bij_v4 = "168.119.100.247";
laurel_v6 = "2a01:4f8:c012:b172::1";
ladon_v6 = "2a01:4f8:1c17:e4ce::1";
sphere_v6 = "2a01:4f8:c012:b842::1";
in {
  zone = {
    TTL = 600;
    SOA = ((ttl 600) {
      nameServer = "ns1.leona.is.";
      adminEmail = "noc@leona.is";
      serial = 2023070501;
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
      "hack.net".AAAA = [ "2a01:4f9:6a:13c6:4000::8de" ];
      "haku.net" = haku_host;
      "kupe.net" = kupe_host;
      "bij.net" = host bij_v4 "2a01:4f8:c010:1098::1";
      "charon.net".AAAA = [ "2a01:4f9:6a:13c6::1" ];
      "dwd.net" = host "195.39.247.151" "2a0f:4ac0:1e0:20::1";
      "enari.net" = host "195.20.227.176" "2001:470:1f0b:1112::1";
      "foros.net" = host "195.39.247.144" "2a01:4f9:6a:13c6:4000::dea";
      "beryl.net" = host "195.39.247.145" "2a01:4f9:6a:13c6:4000::b33";
      "ladon.net".AAAA = [ ladon_v6 ];
      "laurel.net".AAAA = [ laurel_v6 ];
      "turingmachine.net" = host "195.39.247.148" "2a0f:4ac0:1e0:100::1";
      "*.turingmachine.net".CNAME = [ "turingmachine.net.leona.is." ];
      "sphere.net".AAAA = [ sphere_v6 ];
      "wg.net".CNAME = [ "bij.net.leona.is." ];
      "haj-social".CNAME = [ "laurel.net.leona.is." ];

      "ns1" = kupe_host;
      "ns2" = haku_host;
      "ns3" = naiad_host;

      mail = kupe_host;
      autoconfig.CNAME = [ "kupe.net.leona.is." ];
      "wg-sternpunkt".CNAME = [ "wg.net.leona.is." ]; # backwards compatability
      "encladus.lan.int.sig.de".CNAME = [ "encladus.lan." ]; # backwards compatability

      "ca".MX = [ (mx.mx 10 "kupe.net.leona.is.") ];
      "ca".TXT = [ helper.mail.spf ];
      "ca".DKIM = [{
        selector = "mail";
        p = "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA2WJ46bl9UqBY9ZxqkVCBdSiysIJMUbWS3BK10Lupe4T5+jWAcdzJraznWeaVF/mR/9TyiB7lE79ZB6WxHxTwwJ5UZjURwImKAKqSGPXPACIj+LHyx5j2nHN4CawC6bkCmpGT99B7I/5bCelekoAHV9U/4pE2YEjgA0VxvlSKHB2Y7cPWL303DInYGaTrvMczuwLYoEwIiBirffYNqHyrOJE9A+ZQRdLjM8DFOxegAOV9mcHb3MwneJuu86Czz45UIrQ7AxkMUNKgHitqTSnXzLWd4BF6Kf3XUh/lED7WPdviBLJo/1H0Cgch8RRlinTeDVliHDQ6/zLWpk6+k3iKkQIDAQAB";
      }];

      www.CNAME = [ "bij.net.leona.is." ];
      "acme.int".AAAA = [ "fd8f:d15b:9f40:101::100" ];
      auth = host bij_v4 sphere_v6;
      alertmanager.CNAME = [ "naiad.net.leona.is." ];
      cloud.CNAME = [ "bij.net.leona.is." ];
      "cal.cloud".CNAME = [ "bij.net.leona.is." ];
      cv.CNAME = [ "bij.net.leona.is." ];
      fin.CNAME = [ "bij.net.leona.is." ];
      "dataimporter.fin".CNAME = [ "bij.net.leona.is." ];
      git.CNAME = [ "beryl.net.leona.is." ];
      grafana.CNAME = [ "naiad.net.leona.is." ];
      grocy.CNAME = [ "bij.net.leona.is." ];
      "api.grocy".CNAME = [ "bij.net.leona.is." ];
      matrix = host bij_v4 laurel_v6;
      md = host bij_v4 laurel_v6;
      nomsable = host bij_v4 laurel_v6;
      "paperless.int".AAAA = [ "fd8f:d15b:9f40:101::1312" ];
      prometheus.CNAME = [ "naiad.net.leona.is." ];
      sso = host bij_v4 ladon_v6;
      "hydra.sso" = host bij_v4 ladon_v6;
      todo = host bij_v4 laurel_v6;
      pass = host bij_v4 laurel_v6;
      "hass.bn" = host "195.39.247.151" "2a0f:4ac0:1e0:20::1";
      "mqtt.bn.int".A = [ "10.151.5.36" ];
      "mqtt.bn.int".AAAA = [ "fd8f:d15b:9f40:101::1312" ];
      "prometheus.bn.int".AAAA = [ "fd8f:d15b:9f40:101::1312" ];
      yt.CNAME = [ "bij.net.leona.is." ];
      assets.CNAME = [ "bij.net.leona.is." ];
      a.CNAME = [ "bij.net.leona.is." ];
      found.CNAME = [ "bij.net.leona.is." ];
    };
  };
}
