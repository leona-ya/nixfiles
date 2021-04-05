{ helper, dns, config, lib, ... }:

{
  zone = with dns.lib.combinators; {
    TTL = 3600;
    SOA = ((ttl 600) {
      nameServer = "ns1.em0lar.dev.";
      adminEmail = "noc@labcode.de";
      serial = 2021040410;
      refresh = 3600;
      expire = 604800;
      minimum = 600;
    });

    NS = helper.ns;

    MX = helper.mail.mxWithFallback;

    TXT = [ helper.mail.spf ];
    CAA = helper.caa;

    A = helper.hosts.web.A;
    AAAA = helper.hosts.web.AAAA;

    subdomains = {
      "dkim._domainkey".TXT = [
        (txt ''v=DKIM1;k=rsa;t=s;s=email;p=" "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA7tBTDV2m8+2fG6lKNzNni3iXSrn2J+u+a7JkYULEoHHTXz66G1EEOXE8sDvwChEQMqZV6LXMPfLrhubHGnaEHq8a+qmXQ1Xylz252TAyh4XFr1sNH2WTxw/nUZjL7Rlmbmba0bqZwi6rMwd5QRagcsi7UfqPwj5mEsrPXOBDNbQ5l5S+IJ+Wj7M0BAOhON092uBNVseXvuaYNI" "JU2ndmLqmcqHIfsVrfp8yaSBPMilAVT1RciGBgw0T1wy/BU/89AAq/kIIGycNoTR+ZvdU/2K54BFgbzuVgqg0DWINmfJsSblLYfymdsvNsUrETzmR4SH1fVMbCiH9UoT+wUPAU7wIDAQAB'')
      ];
    };
  };
}
