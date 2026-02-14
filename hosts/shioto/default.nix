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
    ../../services/keycloak
    ../../services/ldap
  ];

  l.backups.enable = true;

  services.postgresql.package = pkgs.postgresql_18;

  system.stateVersion = "26.05";
}
