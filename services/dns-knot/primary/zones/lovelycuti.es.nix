{ helper, dns, config, lib, ... }:

{
  zone = with dns.lib.combinators; {
    TTL = 3600;
    SOA = ((ttl 600) {
      nameServer = "ns1.em0lar.dev.";
      adminEmail = "noc@em0lar.dev";
      serial = 2021121501;
      refresh = 3600;
      expire = 604800;
      minimum = 600;
    });

    NS = helper.ns;

    MX = helper.mail.mxSimple;
    DKIM = [{
      selector = "mail";
      p = "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAw8uVXCr8ggi0Sla2CWAxchWA2jHNy9lKe2zKkiSQ+Pjexod3hMtbsi47ywyaoi2SPdMOWYOgGuaPEj65ZRg4fOGTtEC7M/PB/0b4WHMeEo3stLIMtD4UrzLxGXlkuNKO3nWEU+TsYQBOP3kxsChkZ7hRukDflFNCkPNQ8P1SjngZBG1nn+Bo+BIB3OSfe5Tl5wyp54mM08U+eHZI/YOl6nt0WCunXPMKsR7CnP7BE6JJd9tPVHhJxRL5U13COGhMZSQ4wSCJdL3FQ0CGoj4TIY9skTeBAMEkwvTSJ5UKB83Z7Tec6gmrOKZxnbgji9Ja+nGJF0MSJL5jsMSh6bO4sQIDAQAB";
    }];
    DMARC = helper.mail.dmarc;
    TXT = [ helper.mail.spf ];

    CAA = helper.caa;

    A = helper.hosts.web.A;
    AAAA = helper.hosts.web.AAAA;
  };
}
