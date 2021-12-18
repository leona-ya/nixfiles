{ ... }: {
  networking.firewall.allowedTCPPorts = [ 53 ];
  networking.firewall.allowedUDPPorts = [ 53 ];
  services.knot = {
    enable = true;
    extraConfig = ''
      remote:
        - id: internal_ns1
          address: fd8f:d15b:9f40:c31:5054:ff:fec0:8539
      acl:
        - id: internal_notify
          address: [fd8f:d15b:9f40:c31:5054:ff:fec0:8539]
          action: notify
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
        - domain: emolar.de
          template: secondary
        - domain: labcode.de
          template: secondary
        - domain: lbcd.dev
          template: secondary
        - domain: leomaroni.de
          template: secondary
        - domain: lovelycuti.es
          template: secondary
        - domain: maroni.me
          template: secondary
        - domain: opendatamap.net
          template: secondary
    '';
  };
}
