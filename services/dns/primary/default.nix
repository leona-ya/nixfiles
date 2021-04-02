{ config, inputs, lib, pkgs, ... }:

let
  dns = inputs.dns;
  dnsutil = dns.util.${config.nixpkgs.system};

  lbcd_dev_zone = dnsutil.writeZone "lbcd.dev" (import zones/lbcd.dev.nix { inherit lib dns config; }).zone;
in {
  networking.firewall.allowedTCPPorts = [ 53 ];
  networking.firewall.allowedUDPPorts = [ 53 ];

  em0lar.secrets = {
    "dnssec/lbcd.dev/Klbcd.dev.+013+19394.private".owner = "named";
    "dnssec/lbcd.dev/Klbcd.dev.+013+19394.key".owner = "named";
  };

  systemd.services.bind.preStart = ''
    ${pkgs.coreutils}/bin/mkdir -p /run/named/dnssec
    ${pkgs.coreutils}/bin/mkdir -p /run/named/zones
    ${pkgs.coreutils}/bin/chown named /run/named/zones

    # DNSSEC
    ${pkgs.coreutils}/bin/ln -sf ${config.em0lar.secrets."dnssec/lbcd.dev/Klbcd.dev.+013+19394.private".path} /run/named/dnssec/Klbcd.dev.+013+19394.private
    ${pkgs.coreutils}/bin/ln -sf ${config.em0lar.secrets."dnssec/lbcd.dev/Klbcd.dev.+013+19394.key".path} /run/named/dnssec/Klbcd.dev.+013+19394.key

    # Zonefiles
    ${pkgs.coreutils}/bin/ln -sf ${lbcd_dev_zone} /run/named/zones/lbcd.dev.zone
  '';

  em0lar.bind = {
    enable = true;
    extraOptions = ''
      key-directory "dnssec";
      notify explicit;
      also-notify {
        fd8f:d15b:9f40:0c00::1; # haku
        fd8f:d15b:9f40:0c20::1; # naiad
      };
    '';
    zones = [
      {
        name = "lbcd.dev";
        master = true;
        file = "/run/named/zones/lbcd.dev.zone";
        slaves = [ "fd8f:d15b:9f40::/48" ];
        extraConfig = ''
          auto-dnssec maintain;
          inline-signing yes;
        '';
      }
    ];
  };
}
