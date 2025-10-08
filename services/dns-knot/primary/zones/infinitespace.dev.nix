{
  helper,
  dns,
  config,
  lib,
  ...
}:

{
  zone = with dns.lib.combinators; {
    TTL = 3600;
    SOA = (
      (ttl 600) {
        nameServer = "ns1.leona.is.";
        adminEmail = "noc@leona.is";
        serial = 0;
        refresh = 3600;
        expire = 604800;
        minimum = 600;
      }
    );

    NS = helper.ns;

    TXT = [
      helper.mail.spf
    ];
    DMARC = helper.mail.dmarc;

    CAA = helper.caa;

    subdomains = {
      social = host "168.119.100.247" "2a01:4f8:c012:b172::1";
      "dyn".NS = [
        "ns1.leona.is."
        "ns2.leona.is."
        "ns3.leona.is."
      ];
      "dyn".DS = [
        {
          keyTag = 10987;
          algorithm = 13;
          digestType = 2;
          digest = "6a40f03ab95a49f68a9836b4b05be485c23fd6dabdffc0955fd751412811504c";
        }
        {
          keyTag = 10987;
          algorithm = 13;
          digestType = 4;
          digest = "c53550e019d98c639cc76a03b953a1479eb8104ce7db22b9d6b0f41aa06e2a814872beb2828955d439c60758270a7835";
        }
      ];
    };
  };
}
