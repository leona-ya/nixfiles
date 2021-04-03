{ config, inputs, lib, pkgs, ... }:

with inputs.nixpkgs.lib;

let
  dns = inputs.dns;
  dnsutil = dns.util.${config.nixpkgs.system};

  helper = import ./helper.nix { inherit dns; };
  zoneDefinitions = import ../zoneDefinitions.nix { inherit dnsutil helper lib dns config; };
in {
  networking.firewall.allowedTCPPorts = [ 53 ];
  networking.firewall.allowedUDPPorts = [ 53 ];

  systemd.services.bind.preStart = ''
    ${pkgs.coreutils}/bin/mkdir -p /run/named/zones
    ${pkgs.coreutils}/bin/chown named /run/named/zones
  '';

  em0lar.bind = {
    enable = true;
    extraOptions = ''
      notify no;
    '';
    zones = mapAttrsToList (name: zoneConfig: {
      name = "${name}";
      master = false;
      file = "zones/${name}.zone";
      masters = [
        "fd8f:d15b:9f40:0c21::1" # myron
      ];
    }) zoneDefinitions;
  };
}
