{ helper, dns, config, lib, ... }:

{
  zone = with dns.lib.combinators; {
    TTL = 3600;
    SOA = ((ttl 600) {
      nameServer = "ns1.em0lar.dev.";
      adminEmail = "noc@labcode.de";
      serial = 2021040902;
      refresh = 3600;
      expire = 604800;
      minimum = 600;
    });

    NS = helper.ns;

    MX = helper.mail.mxWithFallback;

    TXT = [ helper.mail.spf ];
    DKIM = [{
      selector = "dkim";
      t = [ "s" ];
      s = [ "email" ];
      p = "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA0D9oTjw3GT1mQY7oOb9k7oEqxwFzpH3x0+5I3BzPiahiuhUdXgW5pt1KOddwVLzxsKkqTkTACyLRAaJVX4yKq06GeiIKYE8NU1Tt+N4/cUVjLqWQ8q80u8UkLdgrdIlwBb+p079OXogSnpg0N762bqyB1uEADhUNjRP6lQMYfBAzqVJNkUo4ABm+GsWlcPuhOBc0Sp6F5IhvBx/uyyzz46f/50kHOQgYWCblGwglrX9awEEBiMtWtGNBH7iO0DqL4AiJJC8PBvj2kS5sCdZRfCHRBGPczClmvCWf2JA6pL+PFqwtne35KGFIRHOluv3cn6YzQU3jhTaMMOWrgXHcFQIDAQAB";
    }];

    CAA = helper.caa;

    A = helper.hosts.web.A;
    AAAA = helper.hosts.web.AAAA;

    subdomains = {
      ml.MX = helper.mail.mxWithFallback;
      ml.DKIM = [{
        selector = "dkim";
        t = [ "s" ];
        s = [ "email" ];
        p = "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEApfjwwui6to37BbwmY6O6dTLeF/1MBDqlqWWKyvP+18lGeYG00y+QtTSmyqmens/tjDqX7mTX1v4PIuddT6KMUuvy28VADka4gLtpgReRuF8+4VMyPAN3ziLQapH8Fgw2ZhucdFcz14S8MKls26T94iyrn43UlpqfauxGcPDqbhu18Wfy5EgJLhqlTKYv1xVM2Fvx0k+HQFY7RQMF5gzzY0ToTv3kqbf8r/w39vPgwEODQT2RD5IdbNe5yXTphmwN1+uydFfYqj62EzPUKD4nCCe1RDh5GtHTGAsKt8KdVufZBIML4EYolh8iyIdozn8JtcOqdagE9ToF6gVvtvnkJwIDAQAB";
      }];
      ml.TXT = [ helper.mail.spf ];
      nl.MX = helper.mail.mxSimple;
      nl.TXT = [ helper.mail.spf ];
      ca.MX = helper.mail.mxWithFallback;
      ca.TXT = [ helper.mail.spf ];
      ca.DKIM = [{
        selector = "dkim";
        t = [ "s" ];
        s = [ "email" ];
        p = "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAruAiCE8lXVKqR0nihVRuiLUiAk0yGikVKLj/IsFGvl8GH88DtfaZhss0XCOY9m7fIQPf0j3dh3bFrbh3sPX5hhgZwv+sV/KLR1JhESduVnksZC1w+ZKhjjBoNFkBdSsPuU0bp7KBGjGJ8hS4H3M2AxOF0SnpR1kUAL9j+IFwi0KGuKuuX03RHCZVWGNjt72qKdFRNIW9BlK/AqZXG0toPfkMCRIluH1aGJmN9kIgc8Q/dJeXWfGBgGvW1Idc708XlnoLOkM5Giajmz2+gC+BcOCJf4/WFm7c6ZRzsuM6yVXdKT7bSm4ey6duZ9MIyeDQD83CbsXC6BBwP/JN6ZHrwwIDAQAB";
      }];

      www.CNAME = [ "foros.int.sig.de.em0lar.dev." ];
      auth.CNAME = [ "foros.int.sig.de.em0lar.dev." ];
      element.CNAME = [ "foros.int.sig.de.em0lar.dev." ];
      git.CNAME = [ "beryl.int.sig.de.em0lar.dev." ];
      md.CNAME = [ "beryl.int.sig.de.em0lar.dev." ];
      tell.CNAME = [ "foros.int.sig.de.em0lar.dev." ];
      wifi.CNAME = [ "foros.int.sig.de.em0lar.dev." ];

      "janus.dn42".CNAME = [ "janus.ion.rhr.de.em0lar.dev." ];
    };
  };
}
