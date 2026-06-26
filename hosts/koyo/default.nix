{ inputs, pkgs, ... }:
{
  imports = [
    inputs.mailserver.nixosModules.default
    ../../profiles/moka-libvirt
    ./network.nix
    inputs.disko.nixosModules.disko
    ./disko.nix
    ../../services/dns-knot/primary
    ../../services/dns-kresd
    ../../services/mail
  ];

  system.stateVersion = "26.05";
}
