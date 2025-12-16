{ inputs, pkgs, ... }:
{
  imports = [
    ../../profiles/moka-libvirt
    ./network.nix
    inputs.disko.nixosModules.disko
    ./disko.nix
    ../../services/gitlab
  ];

  services.postgresql.package = pkgs.postgresql_18;

  system.stateVersion = "26.05";
}
