{ helper, dns, config, lib, ... }:

{
  zone = with dns.lib.combinators; {
    TTL = 3600;
    SOA = ((ttl 600) {
      nameServer = "ns1.leona.is.";
      adminEmail = "noc@leona.is";
      serial = 2023082601;
      refresh = 3600;
      expire = 604800;
      minimum = 600;
    });

    NS = helper.ns;

    MX = helper.mail.mxSimple;
    DKIM = [{
      selector = "mail";
      p = "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAzk2+kDmyOc6uaXUa5NfYk/wQ/x5UUqPEfDdqIf9I2K4nCmAJUIHUcKwoW5L/EGzsAKvTSObh7d/HLEWIg2t+NqsBwVwdib1zkspjcp44y3zhSVChML+9LNk6vZq+2GY3E2PBVVZJ9RollgbN/iedh6XKEi5pG7yXc+yl3rgeUZyRlxa3QE0MxqSUcETUUL8qHp5v5AxucwgxxnTq4eGHqsddyZ4+HLGGtzdIYUdqrfkS6za4J4ZVyXCV3kId8L//L3OcxjuHNgGjZeZD+zGgo7QbxixzIS+irD5VWiXuAlMbS0U0lL96619iTv2WGG19TCpEwiJuEg+OtCeWIkibXwIDAQAB";
    }];
    DMARC = helper.mail.dmarc;
    TXT = [
      helper.mail.spf
    ];
    CAA = helper.caa;

    subdomains = {
      autoconfig.CNAME = [ "kupe.net.leona.is." ];
    };
  };
}
