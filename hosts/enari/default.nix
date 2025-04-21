{ inputs, pkgs, ... }: {
  imports = [
    ../../profiles/strato/x86_64
    ./network.nix
    inputs.disko.nixosModules.disko
    ./disko.nix
    ../../services/dns-knot/secondary
    ../../services/gitlab
    ../../services/gitlab-runner
  ];

  # Secondary DNS
  services.knot.settings.server.listen = [
    "127.0.0.11@53"
    "195.20.227.176@53"
    "2a02:247a:22e:fd00:1::1@53"
    "fd8f:d15b:9f40:c10::1@53"
  ];

#  l.backups.enable = true;

  services.postgresql.package = pkgs.postgresql_15;

  system.stateVersion = "25.05";
}
