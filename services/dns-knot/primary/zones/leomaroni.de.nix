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
    DKIM = [{
      selector = "mail";
      p = "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAt5yOpQ86C+iZUnyuqBAoOqUAnVrngnZ3Ifj+ij2UMeHEUh9Opd8RCwKINLC84yNPHP2lSaNfseNadKozkVmUTTMXaD606v0qAzU8e4mx7YF80+g6XHugm6skkKZ/C00eGfJIsU/74e9eV96vN9QTP9BpMstcDdaCzKKhJbUD/waXDx3QKhJ5iKH8KAT2B2pfS2Rhb4HkyxDDGCazTLkgXCJlbU3ZR6kNPYouZ6NM/S7SsBPI/2/ewnso59pPFy9VsgMqUzVCPQ/B3aXr1Y4mHuBsBvDJYlk3SYCfrsVcMKu/l0fSrph8AGJyQ7Kz30SxoSbfZhCkMIXgfE/K1jcjSwIDAQAB";
    }];
    DMARC = helper.mail.dmarc;
    TXT = [
      helper.mail.spf
      "google-site-verification=VV1yAQsf26RrJxUXjd-LGIRjQnO9TZ32uu8XeU0fu6U"
    ];

    CAA = helper.caa;

    A = helper.hosts.web.A;
    AAAA = helper.hosts.web.AAAA;

    subdomains = {
      nl.MX = helper.mail.mxSimple;
      nl.TXT = [ helper.mail.spf ];
      services.MX = helper.mail.mxSimple;
      services.DKIM = [{
        selector = "dkim";
        t = [ "s" ];
        s = [ "email" ];
        p = "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA2HWgAPc+JvAItn1icsdsMVjeVAw5gk4ISR8aWe8Npt1hWsJeeoIRxRThuL6Z3+ERlFEwNhb9O8VbK7QzhcE5HvRWo47pqVN/Q2wRfX8Y0aFx2KVHXVZt3rCivQAWaqSa+wfJFxjAMiSNz7sZk9yjex4+ErSdKH4wmNhiYYgBaZlGhWgUz8dhASVBHI9BXhVZjaVBjmn8CpVHw2OUHI+rfXUEzwiyJf319+xOaVnytzF55Nb++HSwxboqQfR+BgiWxzC5WZDRSgs7VQnlLn8DFEjPOhU8leTttAqSf71I6nDf7bcKBL0yhfEmM2Jm7awVc2KUZF5zWQea9l716tBOyQIDAQAB";
      }];
      services.TXT = [ helper.mail.spf ];

      www.CNAME = [ "foros.net.leona.is." ];
      gat.CNAME = [ "foros.net.leona.is." ];
      cloud.CNAME = [ "foros.net.leona.is." ];
      "shared.cloud".CNAME = [ "haku.net.leona.is." ];
      "shared.cloud.int".CNAME = [ "foros.net.leona.is." ];
    };
  };
}
