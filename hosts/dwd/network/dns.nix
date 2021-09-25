{ ... }: {
  services.resolved.enable = false;
  services.kresd = {
    enable = true;
    extraConfig = ''
      policy.add(policy.suffix(policy.FLAGS({'NO_CACHE', 'NO_EDNS'}), {todname('lan.')}))
      policy.add(policy.suffix(policy.STUB({'127.0.0.11'}), {todname('lan.')}))

      policy.add(policy.all(
        policy.FORWARD({
          '2620:fe::11',
          '2620:fe::fe:11',
          '9.9.9.11',
          '149.112.112.11'
        })
      ))
    '';
    listenPlain = [
      "127.0.0.1:53"
      "[::1]:53"
      "10.151.0.1:53"
      "[fd8f:d15b:9f40:10::1]:53"
      "10.151.4.254:53"
      "[fd8f:d15b:9f40:11::1]:53"
      "10.151.6.1:53"
    ];
  };
  services.knot = {
    enable = true;
    extraConfig = ''
      server:
        listen: 127.0.0.11@53
      acl:
        - id: internal_transfer
          address: 127.0.0.0/8
          action: transfer
        - id: local_update
          address: 127.0.0.0/8
          action: update
      mod-rrl:
        - id: default
          rate-limit: 200   # Allow 200 resp/s for each flow
          slip: 2           # Every other response slips
      template:
        - id: default
          semantic-checks: on
          global-module: mod-rrl/default
        - id: primary_update
          acl: [local_update, internal_transfer]
      zone:
        - domain: lan
          file: "/var/lib/knot/zones/lan.zone"
          template: primary_update
    '';
  };
}
