{ inputs, pkgs, ... }:
{
  imports = [
    ../../profiles/moka-libvirt
    ./network.nix
    inputs.disko.nixosModules.disko
    ./disko.nix
    ../../services/dns-knot/primary
  ];

  l.meta.bootstrap = true;

  system.stateVersion = "26.05";
}
