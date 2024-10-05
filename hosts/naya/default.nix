{ inputs, ... }: {
  imports = [
    ../../profiles/hetzner/x86_64
    ./network.nix
    inputs.disko.nixosModules.disko
    ./disko.nix
    ../../services/staging/keycloak
  ];

  system.stateVersion = "24.11";
}
