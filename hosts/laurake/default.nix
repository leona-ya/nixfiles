{
  inputs,
  pkgs,
  lib,
  config,
  ...
}:
{
  imports = [
    ../../profiles/moka-libvirt
    ./network.nix
    inputs.disko.nixosModules.disko
    ./disko.nix
    ../../services/hedgedoc
    ../../services/matrix
    ../../services/outline
    ../../services/vaultwarden
    ../../services/netbox
    ../../services/tandoor
    ../../services/gotosocial-is
  ];

  services.postgresql.package = pkgs.postgresql_18;

  system.stateVersion = "26.05";
}
