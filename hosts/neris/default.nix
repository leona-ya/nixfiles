{ inputs, pkgs, ... }:
{
  imports = [
    ../../profiles/moka-libvirt
    ./network.nix
    inputs.disko.nixosModules.disko
    ./disko.nix
    ../../services/staging/keycloak
  ];

  services.postgresql.package = pkgs.postgresql_16;

  system.stateVersion = "26.05";
}
