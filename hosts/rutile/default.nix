{ inputs, pkgs, ... }:
{
  imports = [
    ../../profiles/strato/x86_64
    ./network.nix
    inputs.disko.nixosModules.disko
    ./disko.nix
    ../../services/monitoring
    #    ../../services/plausible
  ];

  #l.backups.enable = true;

  services.postgresql.package = pkgs.postgresql_15;

  system.stateVersion = "25.05";
}
