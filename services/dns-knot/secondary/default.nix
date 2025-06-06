{ config, ... }: {
  networking.firewall.allowedTCPPorts = [ 53 ];
  networking.firewall.allowedUDPPorts = [ 53 ];
  l.sops.secrets."services/dns-knot-secondary/keys".owner = "knot";
  services.knot = {
    enable = true;
    keyFiles = [
      config.sops.secrets."services/dns-knot-secondary/keys".path
    ];
    settings = {
      remote = {
        internal_ns1 = {
          address = "fd8f:d15b:9f40:c21:300::1";
        };
        fdg_ns1 = {
          address = "2a01:4f8:c012:5ab9::1";
          key = "fdg_leona_secondary";
        };
        kloenk_ns1 = {
          address = "2a01:4f8:c013:1a4b::1";
          key = "kloenk_leona_secondary";
        };
      };
      acl = {
        internal_notify = {
          address = [ "fd8f:d15b:9f40:c21:300::1" ];
          action = "notify";
        };
        fdg_notify = {
          address = [ "2a01:4f8:c012:5ab9::1" ];
          action = "notify";
          key = "fdg_leona_secondary";
        };
        kloenk_notify = {
          address = [ "2a01:4f8:c013:1a4b::1" ];
          action = "notify";
          key = "kloenk_leona_secondary";
        };
        internal_transfer = {
          address = [ "fd8f:d15b:9f40::/48" "127.0.0.0/8" ];
          action = "transfer";
        };
      };
      mod-rrl = {
        default = {
          rate-limit = 200; # Allow 200 resp/s for each flow
          slip = 2; # Every other response slips
        };
      };
      template = {
        default = {
          semantic-checks = true;
          global-module = "mod-rrl/default";
        };
        secondary = {
          master = "internal_ns1";
          acl = "internal_notify";
        };
        kloenk_secondary = {
          master = "kloenk_ns1";
          acl = "kloenk_notify";
        };
      };
      zone = {
        "leona.catzone" = {
          catalog-role = "interpret";
          catalog-template = "secondary";
          master = "internal_ns1";
          acl = "internal_notify";
        };


        # fdg
        "fahrplandatengarten.de" = {
          master = "fdg_ns1";
          acl = "fdg_notify";
        };

        # kloenk
        "kloenk.de" = {
          template = "kloenk_secondary";
        };
        "kloenk.dev" = {
          template = "kloenk_secondary";
        };
        "kloenk.eu" = {
          template = "kloenk_secondary";
        };
        "p3tr1ch0rr.de" = {
          template = "kloenk_secondary";
        };
        "sysbadge.dev" = {
          template = "kloenk_secondary";
        };
      };
    };
  };
}
