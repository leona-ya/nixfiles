{
  helper,
  dns,
  config,
  lib,
  ...
}:

{
  zone = with dns.lib.combinators; {
    TTL = 600;
    SOA = (
      (ttl 600) {
        nameServer = "ns1.leona.is.";
        adminEmail = "noc@leona.is";
        serial = 0;
        refresh = 3600;
        expire = 604800;
        minimum = 300;
      }
    );

    NS = helper.ns;

    CAA = helper.caa;

    MX = helper.mail.mxSimple;

    A = [ "195.20.227.176" ];
    AAAA = [ "2a02:2479:56:500::1" ];
  };
}
