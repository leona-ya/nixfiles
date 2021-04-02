{ dns, config, lib, ... }:

{
  zone = with dns.lib.combinators; {
    SOA = ((ttl 600) {
      nameServer = "ns.em0lar.dev.";
      adminEmail = "noc@labcode.de";
      serial = 2021030112;
      refresh = 3600;
      expire = 604800;
      minimum = 600;
    });

    NS = [ "ns1.em0lar.dev." "ns2.em0lar.dev." "ns3.em0lar.dev." ];

    A = map (ttl 60) [ (a "195.39.247.144") ];
    AAAA = map (ttl 600) [ (aaaa "2a0f:4ac0:1e0:100::1") ];
  };
}
