{ inputs, lib, config, ... }:

let
  dns = inputs.dns;
  dnsutil = dns.util.${config.nixpkgs.system};
  helper = import ./zones/helper.nix { inherit dns; };
in {
  "bechilli.de" = {
    zone = dnsutil.writeZone "bechilli.de" (import zones/bechilli.de.nix { inherit helper lib dns config; }).zone;
    dnssec = true;
    dnssecKeyID = "59949";
    dnssecKeyAlgorithm = "013";
  };
  "em0lar.de" = {
    zone = dnsutil.writeZone "em0lar.de" (import zones/em0lar.de.nix { inherit helper lib dns config; }).zone;
    dnssec = true;
    dnssecKeyID = "33650";
    dnssecKeyAlgorithm = "013";
  };
  "em0lar.dev" = {
    zone = dnsutil.writeZone "em0lar.dev" (import zones/em0lar.dev.nix { inherit helper lib dns config; }).zone;
    #dnssec = true;
    #dnssecKeyID = "31689";
    #dnssecKeyAlgorithm = "013";
  };
  "emolar.de" = {
    zone = dnsutil.writeZone "emolar.de" (import zones/emolar.de.nix { inherit helper lib dns config; }).zone;
    dnssec = true;
    dnssecKeyID = "15745";
    dnssecKeyAlgorithm = "013";
  };
  "lbcd.dev" = {
    zone = dnsutil.writeZone "lbcd.dev" (import zones/lbcd.dev.nix { inherit helper lib dns config; }).zone;
    dnssec = true;
    dnssecKeyID = "19394";
    dnssecKeyAlgorithm = "013";
  };
  "labcode.de" = {
    zone = dnsutil.writeZone "labcode.de" (import zones/labcode.de.nix { inherit helper lib dns config; }).zone;
    dnssec = true;
    dnssecKeyID = "58290";
    dnssecKeyAlgorithm = "013";
  };
  "leomaroni.de" = {
    zone = dnsutil.writeZone "leomaroni.de" (import zones/leomaroni.de.nix { inherit helper lib dns config; }).zone;
    dnssec = true;
    dnssecKeyID = "01792";
    dnssecKeyAlgorithm = "013";
  };
  "lovelycuti.es" = {
    zone = dnsutil.writeZone "lovelycuti.es" (import zones/lovelycuti.es.nix { inherit helper lib dns config; }).zone;
  };
  "opendatamap.net" = {
    zone = dnsutil.writeZone "opendatamap.net" (import zones/opendatamap.net.nix { inherit helper lib dns config; }).zone;
    dnssec = true;
    dnssecKeyID = "56965";
    dnssecKeyAlgorithm = "013";
  };
}
