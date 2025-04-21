{ hosthelper, helper, dns, config, lib, ... }:

with dns.lib.combinators;

let
  enari_host = host "195.20.227.176" "2a02:247a:22e:fd00:1::1";
  kupe_host = host "159.69.17.61" "2a01:4f8:1c1c:f0b::1";
  bij_v4 = "168.119.100.247";
  bij_host = host bij_v4 "2a01:4f8:c010:1098::1";
  laurel_v6 = "2a01:4f8:c012:b172::1";
  sphere_v6 = "2a01:4f8:c012:b842::1";
  naya_v6 = "2a01:4f8:1c17:51ec::1";
in
{
  zone = {
    TTL = 3600;
    SOA = ((ttl 3600) {
      nameServer = "ns1.leona.is.";
      adminEmail = "noc@leona.is";
      serial = 0;
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
      "kupe.net" = kupe_host;
      "bij.net" = bij_host;
      "dwd.net" = host "195.39.247.151" "2a0f:4ac0:1e0:20::1";
      "enari.net" = enari_host;
      "laurel.net".AAAA = [ laurel_v6 ];
      "naya.net".AAAA = [ naya_v6 ];
      "rutile.net" = host "87.106.216.104" "2a01:239:33f:4a00::1";
      "turingmachine.net" = host "195.39.247.148" "2a0f:4ac0:1e0:100::1";
      "*.turingmachine.net".CNAME = [ "turingmachine.net.leona.is." ];
      "sphere.net".AAAA = [ sphere_v6 ];
      "wg.net".CNAME = [ "bij.net.leona.is." ];
      "haj-social".CNAME = [ "laurel.net.leona.is." ];

      "ns1" = kupe_host;
      "ns2" = enari_host;
      "ns3" = bij_host;

      "acme".NS = [ "ns1.leona.is." "ns2.leona.is." "ns3.leona.is." ];
      "acme".DS = [
        { keyTag = 33964; algorithm = 13; digestType = 2; digest = "7f656ab266f7bfd2ba7e7712e063037726290eaf5aad3188ef941fd5fe68bd77"; }
        { keyTag = 33964; algorithm = 13; digestType = 4; digest = "bb61dfe2ef1b5c3223a0075bd51c10e288e2ba7db4cbd01a86de5e1e719e0ba7a2e396a3e358ae2961c444c35ddb2626"; }
      ];

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
      "ldap".CNAME = [ "sphere.net.leona.is." ];
      alertmanager.CNAME = [ "rutile.net.leona.is." ];
      cloud.CNAME = [ "bij.net.leona.is." ];
      "cal.cloud".CNAME = [ "bij.net.leona.is." ];
      cv.CNAME = [ "bij.net.leona.is." ];
      fin.CNAME = [ "bij.net.leona.is." ];
      "dataimporter.fin".CNAME = [ "bij.net.leona.is." ];
      grocy.CNAME = [ "bij.net.leona.is." ];
      "api.grocy".CNAME = [ "bij.net.leona.is." ];
      matrix = host bij_v4 laurel_v6;
      "mautrix-telegram.matrix" = host bij_v4 laurel_v6;
      "sliding-sync.matrix" = host bij_v4 laurel_v6;
      md = host bij_v4 laurel_v6;
      netbox = host bij_v4 laurel_v6;
      nomsable = host bij_v4 laurel_v6;
      "paperless.int".AAAA = [ "fd8f:d15b:9f40:101::1312" ];
      todo = host bij_v4 laurel_v6;
      pass = host bij_v4 laurel_v6;
      "hass.bn" = host "195.39.247.151" "2a0f:4ac0:1e0:20::1";
      "mqtt.bn.int".A = [ "10.151.5.49" ];
      "mqtt.bn.int".AAAA = [ "fd8f:d15b:9f40:101::1312" ];
      "prometheus.bn.int".AAAA = [ "fd8f:d15b:9f40:101::1312" ];
      yt.CNAME = [ "bij.net.leona.is." ];
      assets.CNAME = [ "bij.net.leona.is." ];
      a.CNAME = [ "bij.net.leona.is." ];
      found.CNAME = [ "bij.net.leona.is." ];
      openpgpkey.CNAME = [ "bij.net.leona.is." ];
      kb.CNAME = [ "laurel.net.leona.is." ];
      "grafana.mon".CNAME = [ "rutile.net.leona.is." ];
      "metrics.mon".CNAME = [ "rutile.net.leona.is." ];
      "logs.mon".CNAME = [ "rutile.net.leona.is." ];
    };
  };
}
