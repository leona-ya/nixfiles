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

    subdomains = rec {
      "biro.net" = host "95.217.67.8" "2a01:4f9:3a:1448:4000:b11::";
      "moka.net" = host "135.181.140.95" "2a01:4f9:3a:1448::";
      "neris.net".AAAA = [ "2a01:4f9:3a:1448:4000:4a1a::" ];
      "install-iso.moka.net".AAAA = [ "2a01:4f9:3a:1448:7fff:1487:a11::" ];
      "laurake.net".AAAA = [ "2a01:4f9:3a:1448:4000:10::" ];
      "shioto.net".AAAA = [ "2a01:4f9:3a:1448:4000:11::" ];
      "auth.stag".A = helper.hosts.web.A;
      "auth.stag".AAAA = [ "2a01:4f9:3a:1448:4000:4a1a::" ];
      social.A = helper.hosts.web.A;
      social.AAAA = [ "2a01:4f9:3a:1448:4000:10::" ];
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
