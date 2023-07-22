{ config, ... }: {
  networking.firewall.allowedTCPPorts = [ 53 ];
  networking.firewall.allowedUDPPorts = [ 53 ];
  l.sops.secrets."services/dns-knot-secondary/keys".owner = "knot";
  services.knot = {
    enable = true;
    keyFiles = [
      config.sops.secrets."services/dns-knot-secondary/keys".path
    ];
    extraConfig = ''
      remote:
        - id: internal_ns1
          address: fd8f:d15b:9f40:c21:300::1
        - id: fdg_ns1
          address: 2a01:4f8:c012:5ab9::1
          key: fdg_leona_secondary
      acl:
        - id: internal_notify
          address: [fd8f:d15b:9f40:c21:300::1]
          action: notify
        - id: fdg_notify
          address: [2a01:4f8:c012:5ab9::1]
          action: notify
          key: fdg_leona_secondary
        - id: internal_transfer
          address: [fd8f:d15b:9f40::/48, 127.0.0.0/8]
          action: transfer
      mod-rrl:
        - id: default
          rate-limit: 200   # Allow 200 resp/s for each flow
          slip: 2           # Every other response slips
      template:
        - id: default
          semantic-checks: on
          global-module: mod-rrl/default
        - id: secondary
          master: internal_ns1
          acl: internal_notify
      zone:
        - domain: bechilli.de
          template: secondary
        - domain: em0lar.de
          template: secondary
        - domain: em0lar.dev
          template: secondary
        - domain: labcode.de
          template: secondary
        - domain: leona.is
          template: secondary
        - domain: maroni.me
          template: secondary
        - domain: opendatamap.net
          template: secondary
        - domain: fahrplandatengarten.de
          master: fdg_ns1
          acl: fdg_notify
    '';
  };
}
