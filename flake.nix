{
  description = "em0lar's NixOS config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-20.09";
    home-manager = {
      url = "github:nix-community/home-manager/release-20.09";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-registry.url = "github:NixOS/flake-registry";
    flake-registry.flake = false;
    deploy-rs.url = "github:serokell/deploy-rs";
  };

  outputs = inputs@{ self, nixpkgs, home-manager, flake-registry, deploy-rs, ... }:
    let
      mkDeployNodes = deploy: builtins.mapAttrs (_: config: {
        hostname = config.config.networking.hostName + "." + config.config.networking.domain;
        sshOpts = [ "-p" "61337" "-o" "StrictHostKeyChecking=no"];
        profiles.system = {
          user = "root";
          sshUser = "em0lar";
          path = deploy.lib.x86_64-linux.activate.nixos config;
        };
      });
      defaultModules = [
        {
          nix.nixPath = [
            "nixpkgs=${nixpkgs}"
            "home-manager=${home-manager}"
          ];
          nix.extraOptions = ''
            flake-registry = ${flake-registry}/flake-registry.json
          '';
          nix.registry = {
            home-manager.flake = home-manager;
            nixpkgs.flake = nixpkgs;
          };
          imports = [
            ./modules/backups
            ./modules/nftables
            ./modules/secrets
          ];
          documentation.info.enable = false;
        }
        home-manager.nixosModules.home-manager
      ];
    in {
    nixosConfigurations = {
      aido = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = defaultModules ++ [
          ./hosts/aido/configuration.nix
        ];
      };
      haku = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = defaultModules ++ [
          ./hosts/haku/configuration.nix
        ];
      };
      mimas = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = defaultModules ++ [
          ./hosts/mimas/configuration.nix
        ];
      };
    };
    deploy.nodes = mkDeployNodes deploy-rs self.nixosConfigurations;
  };
}
