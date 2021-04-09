{ helper, dns, config, lib, ... }:

{
  zone = with dns.lib.combinators; {
    TTL = 3600;
    SOA = ((ttl 600) {
      nameServer = "ns1.em0lar.dev.";
      adminEmail = "noc@labcode.de";
      serial = 2021040901;
      refresh = 3600;
      expire = 604800;
      minimum = 600;
    });

    NS = helper.ns;

    MX = helper.mail.mxWithFallback;
    DKIM = [{
      selector = "dkim";
      t = [ "s" ];
      s = [ "email" ];
      p = "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEApB8Rj1Jj6jdrRw+4j++ecDC+eEI58oqnf+7TjO6XDUghsXULl+1N4rft5CjJo1JyNNTr+4v+PHY/CtjGi69USJRYAGUOx4O2R53+BlB/p7I7xkSaOAicp4ug5qjJA1UMLg2u11kfUyz2sYt0yTgIUnZglN7F/PBinm4sotyDnBiPpnB4AKnR0KmGQUvqpriFQWH8HvQbO2LofDRl/B+sk7QKPxuxEDRdkbuq92T0XBNY1Ew1Hwp0FCAvHKhU4iqo05CSU3sAPTU9XzkAghvIVe0dmjjTB0cOzhJduFH6OA10PiwCayGAgJzzKVSFqx7JlQde+ScZS9douChfP6HzHwIDAQAB";
    }];

    TXT = [ helper.mail.spf ];
    CAA = helper.caa;

    A = helper.hosts.web.A;
    AAAA = helper.hosts.web.AAAA;

    subdomains = {
      www.CNAME = [ "foros.int.sig.de.em0lar.dev." ];
      auth.CNAME = [ "foros.int.sig.de.em0lar.dev." ];
      git.CNAME = [ "beryl.int.sig.de.em0lar.dev." ];
      md.CNAME = [ "beryl.int.sig.de.em0lar.dev." ];
    };
  };
}
