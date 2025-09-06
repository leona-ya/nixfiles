{ config, pkgs, ... }:
{
  l.sops.secrets."hosts/${config.networking.hostName}/acme_tsig_key" = { };
  security.acme = {
    acceptTerms = true;
    defaults = {
      email = "noc@leona.is";
      keyType = "ec384";
      dnsProvider = "rfc2136";
      environmentFile = "${pkgs.writeText "acme-dns-env" ''
        RFC2136_NAMESERVER=ns1.leona.is
        RFC2136_TSIG_KEY=acme-nix-${config.networking.hostName}
        RFC2136_TSIG_ALGORITHM=hmac-sha256.
      ''}";
      credentialFiles = {
        "RFC2136_TSIG_SECRET_FILE" =
          config.sops.secrets."hosts/${config.networking.hostName}/acme_tsig_key".path;
      };
    };
  };
}
