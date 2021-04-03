{ dnsutil, helper, lib, dns, config, ... }:

{
  "lbcd.dev" = {
    zone = dnsutil.writeZone "lbcd.dev" (import zones/lbcd.dev.nix { inherit helper lib dns config; }).zone;
    dnssec = true;
    dnssecKeyID = "19394";
    dnssecKeyAlgorithm = "013";
  };
  "opendatamap.net" = {
    zone = dnsutil.writeZone "opendatamap.net" (import zones/opendatamap.net.nix { inherit helper lib dns config; }).zone;
    dnssec = true;
    dnssecKeyID = "56965";
    dnssecKeyAlgorithm = "013";
  };
}
