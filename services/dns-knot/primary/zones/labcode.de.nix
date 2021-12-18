{ helper, dns, config, lib, ... }:

{
  zone = with dns.lib.combinators; {
    TTL = 600;
    SOA = ((ttl 600) {
      nameServer = "ns1.em0lar.dev.";
      adminEmail = "noc@em0lar.dev";
      serial = 2021121501;
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
      "dione.int.sig.de".CNAME = [ "foros.net.em0lar.dev." ]; # backwards compatibility
      "nas.home".CNAME = [ "encladus.lan." ]; # backwards compatibility

      ns = host "95.216.160.224" "2a01:4f9:c010:1dcf::1"; # cetus

      www.CNAME = [ "foros.net.em0lar.dev." ];
      auth.CNAME = [ "foros.net.em0lar.dev." ];
      cdn.CNAME = [ "foros.net.em0lar.dev." ];
      git.CNAME = [ "beryl.net.em0lar.dev." ];
      matrix.CNAME = [ "beryl.net.em0lar.dev." ];
      mautrix-telegram.CNAME = [ "beryl.net.em0lar.dev." ];
      md.CNAME = [ "beryl.net.em0lar.dev." ];
      static.CNAME = [ "foros.net.em0lar.dev." ];
      wifi.CNAME = [ "foros.net.em0lar.dev." ];
    };
  };
}
