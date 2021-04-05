{ helper, dns, config, lib, ... }:

with dns.lib.combinators;

let
myron_host = host "95.217.178.242" "2a01:4f9:c010:beb5::1";
haku_host = host "195.39.247.188" "2a0f:4ac0:0:1::d25";
naiad_host = host "37.120.184.164" "2a03:4000:f:85f::1";
in {
  zone = {
    TTL = 3600;
    SOA = ((ttl 600) {
      nameServer = "ns1.em0lar.dev.";
      adminEmail = "noc@labcode.de";
      serial = 2021040502;
      refresh = 3600;
      expire = 604800;
      minimum = 600;
    });

    NS = helper.ns;

    MX = helper.mail.mxSimple;

    TXT = [ helper.mail.spf ];
    CAA = helper.caa;

    A = helper.hosts.web.A;
    AAAA = helper.hosts.web.AAAA;

    subdomains = {
      "cetus.het.hel.fi" = host "95.216.160.224" "2a01:4f9:c010:1dcf::1";
      "janus.ion.rhr.de" = host "93.90.205.65" "2001:8d8:1800:30a::1";
      "myron.het.hel.fi" = myron_host;
      "naiad.ncp.nue.de" = naiad_host;
      "haku.pbb.wob.de" = haku_host;
      "foros.int.sig.de" = host "195.39.247.144" "2a0f:4ac0:1e0:100::1";
      "beryl.int.sig.de" = host "195.39.247.145" "2a0f:4ac0:1e0:101::1";
      "ns.int.sig.de" = host "10.151.0.1" "fd8f:d15b:9f40::1";
      "lan.int.sig.de" = delegateTo [
        "ns.int.sig.de"
      ];

      "ns1" = myron_host;
      "ns2" = haku_host;
      "ns3" = naiad_host;

      "dkim._domainkey".TXT = [
        (txt ''v=DKIM1;k=rsa;t=s;s=email;p=" "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA0D9oTjw3GT1mQY7oOb9k7oEqxwFzpH3x0+5I3BzPiahiuhUdXgW5pt1KOddwVLzxsKkqTkTACyLRAaJVX4yKq06GeiIKYE8NU1Tt+N4/cUVjLqWQ8q80u8UkLdgrdIlwBb+p079OXogSnpg0N762bqyB1uEADhUNjRP6lQMYfBAzqVJNkUo4ABm+GsWlcPuhOBc0Sp6F5IhvBx/" "uyyzz46f/50kHOQgYWCblGwglrX9awEEBiMtWtGNBH7iO0DqL4AiJJC8PBvj2kS5sCdZRfCHRBGPczClmvCWf2JA6pL+PFqwtne35KGFIRHOluv3cn6YzQU3jhTaMMOWrgXHcFQIDAQAB'')
      ];
      backupmx.CNAME = [ "cetus.het.hel.fi.em0lar.dev." ];
      "wg-sternpunkt".CNAME = [ "haku.pbb.wob.de.em0lar.dev." ];

      www.CNAME = [ "foros.int.sig.de.em0lar.dev." ];
      auth.CNAME = [ "foros.int.sig.de.em0lar.dev." ];
      git.CNAME = [ "beryl.int.sig.de.em0lar.dev." ];
      grafana.CNAME = [ "naiad.ncp.nue.de.em0lar.dev." ];
      md.CNAME = [ "beryl.int.sig.de.em0lar.dev." ];
      stun.CNAME = [ "cetus.het.hel.fi.em0lar.dev." ];
      turn.CNAME = [ "cetus.het.hel.fi.em0lar.dev." ];
      webmail.CNAME = [ "foros.int.sig.de.em0lar.dev." ];
      wifi.CNAME = [ "foros.int.sig.de.em0lar.dev." ];
    };
  };
}
