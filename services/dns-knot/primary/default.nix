{ inputs, pkgs, config, lib, ... }:
let
  dns = inputs.dns;
  dnsutil = dns.util.${pkgs.stdenv.hostPlatform.system};
  helper = import ./zones/helper.nix { inherit dns; };
  hosthelper = import ../../../hosts/helper.nix { inherit lib config; };
in
{
  networking.firewall.allowedTCPPorts = [ 53 ];
  networking.firewall.allowedUDPPorts = [ 53 ];
  services.knot = {
    enable = true;
    settings = {
      server.listen = [
        "127.0.0.11@53"
        "159.69.17.61@53"
        "2a01:4f8:1c1c:f0b::1@53"
        "fd8f:d15b:9f40:c21:300::1@53"
      ];
      remote = {
        internal_ns2 = {
          address = "fd8f:d15b:9f40:0c10::1";
        };
        internal_ns3 = {
          address = "fd8f:d15b:9f40:0c21::1";
        };
      };
      acl.internal = {
        address = [ "fd8f:d15b:9f40::/48" "127.0.0.0/8" ];
        action = "transfer";
      };
      mod-rrl.default = {
        rate-limit = 200;
        slip = 2;
      };
      policy.ecdsa256 = {
        algorithm = "ecdsap256sha256";
        ksk-size = 256;
        zsk-size = 256;
        zsk-lifetime = "90d";
        nsec3 = true;
      };
      template = {
        default = {
          semantic-checks = true;
          global-module = "mod-rrl/default";
        };
        signedprimary = {
          dnssec-signing = true;
          dnssec-policy = "ecdsa256";
          semantic-checks = true;
          notify = [ "internal_ns2" "internal_ns3" ];
          acl = [ "internal" ];
          zonefile-sync = -1;
          zonefile-load = "difference";
          journal-content = "changes";
          catalog-role = "member";
          catalog-zone = "leona.catzone.";
        };
      };
      zone = {
        "leona.catzone" = {
          catalog-role = "generate";
          acl = "internal";
        };
        "bechilli.de" = {
          file = dnsutil.writeZone "bechilli.de" (import zones/bechilli.de.nix { inherit helper lib dns config; }).zone;
          template = "signedprimary";
        };
        "em0lar.de" = {
          file = dnsutil.writeZone "em0lar.de" (import zones/em0lar.de.nix { inherit helper lib dns config; }).zone;
          template = "signedprimary";
        };
        "em0lar.dev" = {
          file = dnsutil.writeZone "em0lar.dev" (import zones/em0lar.dev.nix { inherit hosthelper helper lib dns config; }).zone;
          template = "signedprimary";
        };
        "infspace.xyz" = {
          file = dnsutil.writeZone "infspace.xyz" (import zones/infspace.xyz.nix { inherit helper lib dns config; }).zone;
          template = "signedprimary";
        };
        "labcode.de" = {
          file = dnsutil.writeZone "labcode.de" (import zones/labcode.de.nix { inherit helper lib dns config; }).zone;
          template = "signedprimary";
        };
        "leona.is" = {
          file = dnsutil.writeZone "leona.is" (import zones/leona.is.nix { inherit hosthelper helper lib dns config; }).zone;
          template = "signedprimary";
        };
        "maroni.me" = {
          file = dnsutil.writeZone "maroni.me" (import zones/maroni.me.nix { inherit helper lib dns config; }).zone;
          template = "signedprimary";
        };
        "opendatamap.net" = {
          file = dnsutil.writeZone "opendatamap.net" (import zones/opendatamap.net.nix { inherit helper lib dns config; }).zone;
          template = "signedprimary";
        };
      };
    };
  };
}
