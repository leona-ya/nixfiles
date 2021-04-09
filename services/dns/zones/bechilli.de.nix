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

    MX = helper.mail.mxSimple;
    DKIM = [{
      selector = "dkim";
      t = [ "s" ];
      s = [ "email" ];
      p = "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAuISn/WfY8hxks4zcwPXi+mzyTLe5PP4bRS/uTx3ldsjOWWqMyBD5l6UCXoFWedG1rpaUasjh96lglK+GvJdBDd+9pOksMezT/1xhhjO2QT2ughQ1yXFbA4CSraeZOROyWm0KMFLg6Cl9Q4GKsJiLioG/rj6zi6Qq1B7qv/ZgF45BQGYM7tr+mypTWsOpl1JN9ynHrhfp+YrpPbHFIj+Hjs18T6JVLGQw81RQYUi30CrnUYYwYOxCpESdIXdcv4RshdjJmyEP/dwr1GeW6reWkeO0GFV+szAFSzDH0CPMfoS7z8wCMuMk1j2qiRnqgFFpIWbVlgp2Om/bN6fK/tyAeQIDAQAB";
    }];
    TXT = [
      helper.mail.spf
    ];
    CAA = helper.caa;
  };
}
