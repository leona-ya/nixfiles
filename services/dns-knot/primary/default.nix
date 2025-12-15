{
  inputs,
  pkgs,
  config,
  lib,
  ...
}:
let
  dns = inputs.dns;
  dnsutil = dns.util.${pkgs.stdenv.hostPlatform.system};
  helper = import ./zones/helper.nix { inherit dns; };
  hosthelper = import ../../../hosts/helper.nix { inherit lib config; };
  acmeZone = "acme.leona.is";
  hostsWithACMERecords =
    inputs.self.nixosConfigurations
    |> lib.filterAttrs(_: cfg: !cfg.config.l.meta.bootstrap)
    |> lib.filterAttrs (_: cfg: cfg.config.security.acme.certs != { });
  generateACMERecord = recordName: (builtins.hashString "sha1" recordName) + ".${acmeZone}.";
  getAllDomainsPerHost =
    hostName:
    (
      inputs.self.nixosConfigurations.${hostName}.config.security.acme.certs
      |> lib.mapAttrsToList (domain: cfg: [ domain ] ++ cfg.extraDomainNames)
      |> lib.flatten
    );
  ACMERecordsPerHost =
    hostName:
    (hostName |> getAllDomainsPerHost |> builtins.map (recordName: (generateACMERecord recordName)));
  generateACMERecordsPerZone =
    zoneName:
    (
      hostsWithACMERecords
      |> lib.mapAttrsToList (hostName: _: (getAllDomainsPerHost hostName))
      |> lib.flatten
      |> builtins.filter (lib.hasSuffix zoneName)
      |> builtins.map (recordName: {
        name = "_acme-challenge${
          if zoneName != recordName then "." else ""
        }${lib.removeSuffix "${if zoneName != recordName then "." else ""}${zoneName}" recordName}";
        value = {
          CNAME = [ (generateACMERecord recordName) ];
        };
      })
      |> builtins.listToAttrs
    );
in
{
  l.sops.secrets."services/dns-knot-primary/keys".owner = "knot";
  networking.firewall.allowedTCPPorts = [ 53 ];
  networking.firewall.allowedUDPPorts = [ 53 ];
  services.knot = {
    enable = true;
    keyFiles = [
      config.sops.secrets."services/dns-knot-primary/keys".path
    ];
    settings = {
      log.syslog = {
        server = "debug";
        control = "debug";
        zone = "debug";
        any = "debug";
      };
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
      acl = {
        internal = {
          address = [
            "fd8f:d15b:9f40::/48"
            "127.0.0.0/8"
          ];
          action = "transfer";
        };
        dyn_infinitespace_dev_update = {
          key = "dyn.infinitespace.dev_update";
          action = "update";
        };
      }
      // lib.mapAttrs' (hostName: _: {
        name = "acme-nix-${hostName}";
        value = {
          action = "update";
          update-owner = "name";
          update-owner-match = "equal";
          update-owner-name = ACMERecordsPerHost hostName;
          key = [ "acme-nix-${hostName}" ];
        };
      }) hostsWithACMERecords;
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
        cds-cdnskey-publish = "none";
      };
      template =
        let
          notify = {
            notify = [
              "internal_ns2"
              "internal_ns3"
            ];
            acl = [ "internal" ];
            catalog-role = "member";
            catalog-zone = "leona.catzone.";
          };
          dnssec = {
            dnssec-signing = true;
            dnssec-policy = "ecdsa256";
            semantic-checks = true;
            serial-policy = "dateserial";
          };
        in
        {
          default = {
            semantic-checks = true;
            global-module = "mod-rrl/default";
          };
          signedprimary =
            dnssec
            // notify
            // {
              zonefile-sync = -1;
              zonefile-load = "difference-no-serial";
              journal-content = "all";
            };
          signedprimarydynamic =
            dnssec
            // notify
            // {
              zonefile-sync = 0;
              zonefile-load = "difference";
              journal-content = "changes";
              storage = "/var/lib/knot/dynamic-zones";
            };
        };
      zone = {
        "leona.catzone" = {
          catalog-role = "generate";
          acl = "internal";
          storage = "/var/lib/knot/dynamic-zones";
        };
        "bechilli.de" = {
          file =
            dnsutil.writeZone "bechilli.de"
              (import zones/bechilli.de.nix {
                inherit
                  helper
                  lib
                  dns
                  config
                  ;
              }).zone;
          template = "signedprimary";
        };
        "em0lar.de" = {
          file = dnsutil.writeZone "em0lar.de" (
            lib.recursiveUpdate
              (import zones/em0lar.de.nix {
                inherit
                  helper
                  lib
                  dns
                  config
                  ;
              }).zone
              { subdomains = (generateACMERecordsPerZone "em0lar.de"); }
          );
          template = "signedprimary";
        };
        "em0lar.dev" = {
          file = dnsutil.writeZone "em0lar.dev" (
            lib.recursiveUpdate
              (import zones/em0lar.dev.nix {
                inherit
                  hosthelper
                  helper
                  lib
                  dns
                  config
                  ;
              }).zone
              { subdomains = (generateACMERecordsPerZone "em0lar.dev"); }
          );
          template = "signedprimary";
        };
        "forkspace.net" = {
          file = dnsutil.writeZone "forkspace.net" (
            lib.recursiveUpdate
              (import zones/forkspace.net.nix {
                inherit
                  helper
                  lib
                  dns
                  config
                  ;
              }).zone
              { subdomains = (generateACMERecordsPerZone "forkspace.net"); }
          );
          template = "signedprimary";
        };
        "infspace.xyz" = {
          file = dnsutil.writeZone "infspace.xyz" (
            lib.recursiveUpdate
              (import zones/infspace.xyz.nix {
                inherit
                  helper
                  lib
                  dns
                  config
                  ;
              }).zone
              { subdomains = (generateACMERecordsPerZone "infspace.xyz"); }
          );
          template = "signedprimary";
        };
        "infinitespace.dev" = {
          file = dnsutil.writeZone "infinitespace.dev" (
            lib.recursiveUpdate
              (import zones/infinitespace.dev.nix {
                inherit
                  helper
                  lib
                  dns
                  config
                  ;
              }).zone
              { subdomains = (generateACMERecordsPerZone "infinitespace.dev"); }
          );
          template = "signedprimary";
        };
        "dyn.infinitespace.dev" = {
          template = "signedprimarydynamic";
          acl = [
            "internal"
            "dyn_infinitespace_dev_update"
          ];
        };
        "labcode.de" = {
          file = dnsutil.writeZone "labcode.de" (
            lib.recursiveUpdate
              (import zones/labcode.de.nix {
                inherit
                  helper
                  lib
                  dns
                  config
                  ;
              }).zone
              { subdomains = (generateACMERecordsPerZone "labcode.de"); }
          );
          template = "signedprimary";
        };
        "leona.is" = {
          file = dnsutil.writeZone "leona.is" (
            lib.recursiveUpdate
              (import zones/leona.is.nix {
                inherit
                  hosthelper
                  helper
                  lib
                  dns
                  config
                  ;
              }).zone
              { subdomains = (generateACMERecordsPerZone "leona.is"); }
          );
          template = "signedprimary";
        };
        "acme.leona.is" =
          let
            ACMEacl = hostsWithACMERecords |> lib.mapAttrsToList (hostName: _: "acme-nix-${hostName}");
          in
          {
            acl = ACMEacl ++ config.services.knot.settings.template.signedprimarydynamic.acl;
            file = "acme.leona.is.zone";
            template = "signedprimarydynamic";
          };
        "maroni.me" = {
          file = dnsutil.writeZone "maroni.me" (
            lib.recursiveUpdate
              (import zones/maroni.me.nix {
                inherit
                  helper
                  lib
                  dns
                  config
                  ;
              }).zone
              { subdomains = (generateACMERecordsPerZone "maroni.me"); }
          );
          template = "signedprimary";
        };
        "opendatamap.net" = {
          file = dnsutil.writeZone "opendatamap.net" (
            lib.recursiveUpdate
              (import zones/opendatamap.net.nix {
                inherit
                  helper
                  lib
                  dns
                  config
                  ;
              }).zone
              { subdomains = (generateACMERecordsPerZone "opendatamap.net"); }
          );
          template = "signedprimary";
        };
        "nomsable.eu" = {
          file = dnsutil.writeZone "nomsable.eu" (
            lib.recursiveUpdate
              (import zones/nomsable.eu.nix {
                inherit
                  helper
                  lib
                  dns
                  config
                  ;
              }).zone
              { subdomains = (generateACMERecordsPerZone "nomsable.eu"); }
          );
          template = "signedprimary";
        };
      };
    };
  };
}
