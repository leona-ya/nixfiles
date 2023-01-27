{ helper, dns, config, lib, ... }:

{
  zone = with dns.lib.combinators; {
    TTL = 3600;
    SOA = ((ttl 600) {
      nameServer = "ns1.leona.is.";
      adminEmail = "noc@leona.is";
      serial = 2023012602;
      refresh = 3600;
      expire = 604800;
      minimum = 600;
    });

    NS = helper.ns;

    MX = helper.mail.mxSimple;
    DKIM = [{
      selector = "mail";
      p = "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAmWqiz/FQaTndXZaEXT9HE8+MdTowfPxfg8i3TGVIYz9cTf4YdwiwYQgQP/BP0Y0Q+TqloOzOVy03yAbkTzCoj8qwiA76qUhqDQRNavTfWWvxIueuLRZvv92eOcxX+QJA8RnCTzdtuxAoYIQwNiPdEvpJwq/6gpgtjutoyjDETYyN2xLavc1HG7RvTxQE854ivHXgFVggVNNqJclCTITELpXTlIyLe44WZs6KCHF2/MGVlq4ww8asjXR5NpkCMRBeabY75NiVnGXiWSVWMzFWXC03P9Ux736JhkZdE0Uur1Hd/EIuZkQOSXaVID+gMpfO5W1/zN+n+YRV+jxbJ+2SUQIDAQAB";
    }];
    DMARC = helper.mail.dmarc;
    TXT = [
      helper.mail.spf
    ];
    CAA = helper.caa;

    subdomains = {
      autoconfig.CNAME = [ "kupe.net.leona.is." ];
      cloud.CNAME = [ "bij.net.leona.is." ];
      wg.CNAME = [ "bij.net.leona.is." ];
    };
  };
}
