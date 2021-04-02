{ pkgs, ... }:

{
  networking.firewall.allowedTCPPorts = [ 53 ];
  networking.firewall.allowedUDPPorts = [ 53 ];

  systemd.services.bind.preStart = ''
    ${pkgs.coreutils}/bin/mkdir -p /run/named/zones
    ${pkgs.coreutils}/bin/chown named /run/named/zones
  '';

  em0lar.bind = {
    enable = true;
    extraOptions = ''
      key-directory "dnssec";
      notify no;
    '';
    zones = [
      {
        name = "lbcd.dev";
        master = false;
        file = "zones/lbcd.dev.zone";
        masters = [
          "fd8f:d15b:9f40:0c21::1" # myron
        ];
      }
    ];
  };
}
