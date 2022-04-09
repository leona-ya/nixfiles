{ helper, dns, config, lib, ... }:

{
  zone = with dns.lib.combinators; {
    TTL = 600;
    SOA = ((ttl 600) {
      nameServer = "ns1.leona.is.";
      adminEmail = "noc@leona.is";
      serial = 2022032201;
      refresh = 3600;
      expire = 604800;
      minimum = 300;
    });

    NS = helper.ns;

    MX = helper.mail.mxSimple;
    DKIM = [{
      selector = "mail";
      p = "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAqjeXk5Y1xz/5g+Px0YfrtyRDtPTCRKKCpQNDe702xyYlSMhqdVHWAiVQD6fmOzTACKRwoTtdiTjFyk05HJUrtqQegyPa8eFJK9IxIksNfR3yROcdMUZGATCmfwnGAJmawMKBb9UUudynLq1+PYl0LcxvpN0r8nO8tPiPdcPsQVxPuduYSpBzzIxdCLjg0zVmwn88tjC9GF/yxwiZxnMyn4mBSmz/EG9I8iEVBt8v7XJh/UVnu20mRg+osO44605oQPdDf+dXXZ5jgn9hZsACk21ekSex0op6bnVz1mt4c9sPqR1o9atfvNQfol4VUito1y0P3CofLeYGg/avWFvl9QIDAQAB";
    }];
    DMARC = helper.mail.dmarc;
    TXT = [
      helper.mail.spf
      "google-site-verification=rkDXdtr_r_A0_yRGCytx4NTi2WzSFXJS1dD2QN7SgXQ"
    ];

    CAA = helper.caa;

    A = helper.hosts.web.A;
    AAAA = helper.hosts.web.AAAA;

    subdomains = {
      # server
      "dione.int.sig.de".CNAME = [ "foros.net.leona.is." ]; # backwards compatibility
      "nas.home".CNAME = [ "encladus.lan." ]; # backwards compatibility

      www.CNAME = [ "foros.net.leona.is." ];
      auth.CNAME = [ "ladon.net.leona.is." ];
      cdn.CNAME = [ "foros.net.leona.is." ];
      git.CNAME = [ "beryl.net.leona.is." ];
      matrix.CNAME = [ "beryl.net.leona.is." ];
      mautrix-telegram.CNAME = [ "beryl.net.leona.is." ];
      md.CNAME = [ "beryl.net.leona.is." ];
      static.CNAME = [ "foros.net.leona.is." ];
      wifi.CNAME = [ "foros.net.leona.is." ];
    };
  };
}
