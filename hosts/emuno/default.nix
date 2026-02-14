{ inputs, pkgs, ... }:
{
  imports = [
    ../../profiles/moka-libvirt
    ./network.nix
    inputs.disko.nixosModules.disko
    ./disko.nix
    ../../services/gitlab
  ];

  l.backups = {
    enable = true;
    paths = [
      "/home"
      "/var/lib"
      "/root"
      "/var/gitlab"
    ];
  };

  services.postgresql.package = pkgs.postgresql_18;

  system.stateVersion = "26.05";
}
