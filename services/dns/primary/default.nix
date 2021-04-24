{ config, inputs, lib, pkgs, ... }:

with inputs.nixpkgs.lib;

let
  zoneDefinitions = import ../zoneDefinitions.nix { inherit inputs lib config; };
  zoneDefinitionsDNSSEC = filterAttrs (name: zoneConfig: zoneConfig . dnssec or false) zoneDefinitions;
in {
  networking.firewall.allowedTCPPorts = [ 53 ];
  networking.firewall.allowedUDPPorts = [ 53 ];

  em0lar.secrets = mapAttrs' (name: zoneConfig:
    nameValuePair "dnssec/${name}/K${name}.+${zoneConfig.dnssecKeyAlgorithm}+${zoneConfig.dnssecKeyID}.private" { owner = "named"; }
  ) zoneDefinitionsDNSSEC // mapAttrs' (name: zoneConfig:
   nameValuePair "dnssec/${name}/K${name}.+${zoneConfig.dnssecKeyAlgorithm}+${zoneConfig.dnssecKeyID}.key" { owner = "named"; }
  ) zoneDefinitionsDNSSEC;
  systemd.services.bind.serviceConfig.ExecStartPre = [
    "${pkgs.coreutils}/bin/mkdir -p /run/named/dnssec"
    "${pkgs.coreutils}/bin/mkdir -p /var/lib/named/zones"
    "${pkgs.coreutils}/bin/chown named /var/lib/named/zones"
  ] ++ mapAttrsToList (name: zoneConfig:
    "${pkgs.coreutils}/bin/ln -sf ${config.em0lar.secrets."dnssec/${name}/K${name}.+${zoneConfig.dnssecKeyAlgorithm}+${zoneConfig.dnssecKeyID}.private".path} /run/named/dnssec/K${name}.+${zoneConfig.dnssecKeyAlgorithm}+${zoneConfig.dnssecKeyID}.private"
  ) zoneDefinitionsDNSSEC ++ mapAttrsToList (name: zoneConfig:
    "${pkgs.coreutils}/bin/ln -sf ${config.em0lar.secrets."dnssec/${name}/K${name}.+${zoneConfig.dnssecKeyAlgorithm}+${zoneConfig.dnssecKeyID}.key".path} /run/named/dnssec/K${name}.+${zoneConfig.dnssecKeyAlgorithm}+${zoneConfig.dnssecKeyID}.key"
  ) zoneDefinitionsDNSSEC ++ mapAttrsToList (name: zoneConfig:
    "${pkgs.coreutils}/bin/ln -sf ${zoneConfig.zone} /var/lib/named/zones/${name}.zone"
  ) zoneDefinitions;

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
    zones = mapAttrsToList (name: zoneConfig: {
      name = "${name}";
      master = true;
      file = "/var/lib/named/zones/${name}.zone";
      slaves = [ "fd8f:d15b:9f40::/48" ];
      extraConfig = lib.mkIf ( zoneConfig . dnssec or false) ''
        auto-dnssec maintain;
        inline-signing yes;
      '';
    }) zoneDefinitions;
  };
}
