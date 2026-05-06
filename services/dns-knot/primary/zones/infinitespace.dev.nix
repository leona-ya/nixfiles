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

    MX = helper.mail.mxSimple;
    TXT = [
      helper.mail.spf
    ];
    DKIM = [
      {
        selector = "mail";
        p = "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA3NCoEOr844X8fUqNkVJCZj7rAXMmk//L0KlLv75FlVmjl1aXT7t/c+wvg56y9y/RAUDBM8uHOK+IWgR2S8zKknZEaHKLM4fnVBNUYsIMVJ2LHfvCPc/0oh/ZAf1Z7h3VXfeX8vXe8nax+7MTdw2v7ZHnfgfZ8Y3qYvtKQX+l4XeslIMYVkQ5bSmHsX73uShKCxC6RgYTOA6xQDFffkFDhImm95lMgyFxB4sdmchKmjsVf3tYUE5vKP645xBI6CLr7BDw8VTpe1Ab62HpFyhSiU7Y8J6Wgi/1eQ4f8EnYya48+bkT8gSBP8IINL2pRu6D0Ybgt+MBNLa2B5J4MtM/uQIDAQAB";
      }
    ];
    DMARC = helper.mail.dmarc;

    CAA = helper.caa;

    A = helper.hosts.web.A;
    AAAA = helper.hosts.web.AAAA;

    subdomains = {
      "biro.net" = host "95.217.67.8" "2a01:4f9:3a:1448:4000:b11::";
      "emuno.net" = host "95.217.67.9" "2a01:4f9:3a:1448:4000:12::";
      "koyo.net" = host "95.217.67.10" "2a01:4f9:3a:1448:4000:13::";
      "moka.net" = host "135.181.140.95" "2a01:4f9:3a:1448::";
      "neris.net".AAAA = [ "2a01:4f9:3a:1448:4000:4a1a::" ];
      "install-iso.moka.net".AAAA = [ "2a01:4f9:3a:1448:7fff:1487:a11::" ];
      "laurake.net".AAAA = [ "2a01:4f9:3a:1448:4000:10::" ];
      "shioto.net".AAAA = [ "2a01:4f9:3a:1448:4000:11::" ];
      "ceto.net".AAAA = [ "fd8f:d15b:9f40:101:ee0d:9aff:fe2c:2230" ];

      "auth.stag".A = helper.hosts.web.A;
      "auth.stag".AAAA = [ "2a01:4f9:3a:1448:4000:4a1a::" ];
      "discourse.stag".A = helper.hosts.web.A;
      "discourse.stag".AAAA = [ "2a01:4f9:3a:1448:4000:4a1a::" ];

      abs.CNAME = [ "biro.net.infinitespace.dev." ];
      mail.CNAME = [ "koyo.net.infinitespace.dev." ];
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
