{ helper, dns, config, lib, ... }:

{
  zone = with dns.lib.combinators; {
    TTL = 600;
    SOA = ((ttl 600) {
      nameServer = "ns1.leona.is.";
      adminEmail = "noc@leona.is";
      serial = 0;
      refresh = 3600;
      expire = 604800;
      minimum = 300;
    });

    NS = helper.ns;

    CAA = helper.caa;

    A = helper.hosts.web.A;
    AAAA = helper.hosts.web.AAAA;

    subdomains = {
      "auth.stag".A = [ "168.119.100.247" ];
      "auth.stag".AAAA = [ "2a01:4f8:1c17:51ec::1" ];
    };
  };
}
