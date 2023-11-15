{ pkgs, ... }: {
  imports = [
    ../../../services/dns-kresd
  ];
  services.resolved.enable = false;
  services.kresd = {
    listenPlain = [
      "127.0.0.1:53"
      "[::1]:53"
      "10.151.4.1:53"
    ];
  };

  l.telegraf.extraInputs = {
    prometheus =  {
      urls = [ "http://127.0.0.1:8453/metrics" ];
      metric_version = 2;
    };
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
