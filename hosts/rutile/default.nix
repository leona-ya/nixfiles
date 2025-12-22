{ inputs, pkgs, ... }:
{
  imports = [
    ../../profiles/strato/x86_64
    ./network.nix
    inputs.disko.nixosModules.disko
    ./disko.nix
    ../../services/monitoring
    ../../services/dns-knot/secondary
  ];

  #l.backups.enable = true;

  # Secondary DNS
  services.knot.settings.server.listen = [
    "127.0.0.11@53"
    "87.106.216.104@53"
    "2a01:239:33f:4a00::1@53"
    "fd8f:d15b:9f40:c11::1@53"
  ];
  services.postgresql.package = pkgs.postgresql_15;

  system.stateVersion = "25.05";
}
