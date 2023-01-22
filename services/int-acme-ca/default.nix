{ config, ... }: {
  l.sops.secrets = {
    "services/int-acme-ca/intermediate-ca-key".owner = "step-ca";
    "services/int-acme-ca/intermediate-ca-passphrase".owner = "step-ca";
  };
  services.step-ca = {
    enable = true;
    address = "[fd8f:d15b:9f40:101::100]";
    port = 443;
    intermediatePasswordFile = config.sops.secrets."services/int-acme-ca/intermediate-ca-passphrase".path;
    settings = {
      dnsNames = ["acme.int.leona.is"];
      root = ../../lib/leona-is-ca.crt;
      crt = ../../lib/leona-is-acme-ca.crt;
      key = config.sops.secrets."services/int-acme-ca/intermediate-ca-key".path;
      db = {
        type = "badger";
        dataSource = "/var/lib/step-ca/db";
      };
      authority = {
        provisioners = [
          {
            type = "ACME";
            name = "acme";
            claims = {
              maxTLSCertDuration = "720h";
              defaultTLSCertDuration = "720h";
            };
          }
        ];
      };
    };
  };
}
