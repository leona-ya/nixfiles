{ helper, dns, config, lib, ... }:

{
  zone = with dns.lib.combinators; {
    TTL = 600;
    SOA = ((ttl 600) {
      nameServer = "ns1.leona.is.";
      adminEmail = "noc@leona.is";
      serial = 2023082601;
      refresh = 3600;
      expire = 604800;
      minimum = 300;
    });

    NS = helper.ns;

    CAA = helper.caa;

    A = helper.hosts.web.A;
    AAAA = helper.hosts.web.AAAA;

    subdomains = {};
  };
}
