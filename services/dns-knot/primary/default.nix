{ inputs, dns, config, lib, ... }:
let
  dns = inputs.dns;
  dnsutil = dns.util.${config.nixpkgs.system};
  helper = import ./zones/helper.nix { inherit dns; };
  hosthelper = import ../../../hosts { inherit lib config; };
in {
  networking.firewall.allowedTCPPorts = [ 53 ];
  networking.firewall.allowedUDPPorts = [ 53 ];
  services.knot = {
    enable = true;
    extraConfig = ''
      server:
        listen: 127.0.0.11@53
        listen: 195.39.247.146@53
        listen: 2a01:4f8:1c1c:f0b::1@53
        listen: fd8f:d15b:9f40:c21:300::1@53
      remote:
        - id: internal_ns2
          address: fd8f:d15b:9f40:0c00::1
        - id: internal_ns3
          address: fd8f:d15b:9f40:0c20::1
      acl:
        - id: internal
          address: [fd8f:d15b:9f40::/48, 127.0.0.0/8]
          action: transfer
      mod-rrl:
        - id: default
          rate-limit: 200   # Allow 200 resp/s for each flow
          slip: 2           # Every other response slips
      policy:
        - id: ecdsa256
          algorithm: ecdsap256sha256
          ksk-size: 256
          zsk-size: 256
          zsk-lifetime: 90d
          nsec3: on
      template:
        - id: default
          semantic-checks: on
          global-module: mod-rrl/default
        - id: primary
          notify: [internal_ns2, internal_ns3]
          acl: [internal]
          zonefile-sync: -1
          zonefile-load: difference
          journal-content: changes
        - id: signedprimary
          dnssec-signing: on
          dnssec-policy: ecdsa256
          semantic-checks: on
          notify: [internal_ns2, internal_ns3]
          acl: [internal]
          zonefile-sync: -1
          zonefile-load: difference
          journal-content: changes
      zone:
        - domain: bechilli.de
          file: "${dnsutil.writeZone "bechilli.de" (import zones/bechilli.de.nix { inherit helper lib dns config; }).zone}"
          template: signedprimary
        - domain: em0lar.de
          file: "${dnsutil.writeZone "em0lar.de" (import zones/em0lar.de.nix { inherit helper lib dns config; }).zone}"
          template: signedprimary
        - domain: em0lar.dev
          file: "${dnsutil.writeZone "em0lar.dev" (import zones/em0lar.dev.nix { inherit hosthelper helper lib dns config; }).zone}"
          template: signedprimary
        - domain: labcode.de
          file: "${dnsutil.writeZone "labcode.de" (import zones/labcode.de.nix { inherit helper lib dns config; }).zone}"
          template: signedprimary
        - domain: leona.is
          file: "${dnsutil.writeZone "leona.is" (import zones/leona.is.nix { inherit hosthelper helper lib dns config; }).zone}"
          template: signedprimary
        - domain: leomaroni.de
          file: "${dnsutil.writeZone "leomaroni.de" (import zones/leomaroni.de.nix { inherit helper lib dns config; }).zone}"
          template: signedprimary
        - domain: maroni.me
          file: "${dnsutil.writeZone "maroni.me" (import zones/maroni.me.nix { inherit helper lib dns config; }).zone}"
          template: signedprimary
        - domain: opendatamap.net
          file: "${dnsutil.writeZone "opendatamap.net" (import zones/opendatamap.net.nix { inherit helper lib dns config; }).zone}"
          template: signedprimary
    '';
  };
}
