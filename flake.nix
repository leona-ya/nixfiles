{
  description = "em0lar's NixOS config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/master";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-registry.url = "github:NixOS/flake-registry";
    flake-registry.flake = false;
    deploy-rs.url = "github:serokell/deploy-rs";
    em0lar-dev-website = {
      url = "git+https://git.em0lar.dev/em0lar/em0lar.dev?ref=main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dns = {
      url = "github:kirelagin/dns.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    mailserver = {
      url = "gitlab:simple-nixos-mailserver/nixos-mailserver";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, dns, nixpkgs, home-manager, flake-registry, deploy-rs, em0lar-dev-website, mailserver, ... }:
    let
      overlays = [
        (final: prev: import ./packages final prev)
        em0lar-dev-website.overlay
      ];
      legacyPackages."x86_64-linux" = (import nixpkgs {
        system = "x86_64-linux";
      }).extend self.overlays.packages;

      sourcesModule = {
        _file = ./flake.nix;
        _module.args.inputs = inputs;
      };

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
            ./modules/bind
            ./modules/imapsync
            ./modules/nftables
            ./modules/secrets
            ./modules/telegraf
          ];
          documentation.info.enable = false;
        }
        home-manager.nixosModules.home-manager
        {
          nixpkgs.overlays = overlays;
        }
        sourcesModule
      ];

      hosts = {
        aido = {
          nixosSystem = {
            system = "x86_64-linux";
            modules = defaultModules ++ [
              ./hosts/aido/configuration.nix
            ];
          };
          deploy.hostname = "aido.lan.int.sig.de.em0lar.dev";
        };
        beryl = {
          nixosSystem = {
            system = "x86_64-linux";
            modules = defaultModules ++ [
              ./hosts/beryl/configuration.nix
            ];
          };
          deploy.hostname = "beryl.lan.int.sig.de.em0lar.dev";
        };
        foros = {
          nixosSystem = {
            system = "x86_64-linux";
            modules = defaultModules ++ [
              ./hosts/foros/configuration.nix
            ];
          };
          deploy.hostname = "foros.lan.int.sig.de.em0lar.dev";
        };
        haku = {
          nixosSystem = {
            system = "x86_64-linux";
            modules = defaultModules ++ [
              ./hosts/haku/configuration.nix
            ];
          };
        };
        rechaku = {
          nixosSystem = {
            system = "x86_64-linux";
            modules = defaultModules ++ [
              ./hosts/rechaku/configuration.nix
            ];
          };
          deploy.hostname = "49.12.7.88";
        };
        ladon = {
          nixosSystem = {
            system = "x86_64-linux";
            modules = defaultModules ++ [
              ./hosts/ladon/configuration.nix
            ];
          };
          deploy.hostname = "ladon.lan.int.sig.de.em0lar.dev";
        };
        turingmachine = {
          nixosSystem = {
            system = "x86_64-linux";
            modules = defaultModules ++ [
              ./hosts/turingmachine/configuration.nix
            ];
          };
          deploy.hostname = "turingmachine.lan.int.sig.de.em0lar.dev";
        };
        naiad = {
          nixosSystem = {
            system = "x86_64-linux";
            modules = defaultModules ++ [
              ./hosts/naiad/configuration.nix
            ];
          };
        };
        myron = {
          nixosSystem = {
            system = "x86_64-linux";
            modules = defaultModules ++ [
              mailserver.nixosModule
              ./hosts/myron/configuration.nix
            ];
          };
        };
      };
    in {
      nixosConfigurations = (nixpkgs.lib.mapAttrs (name: config: (nixpkgs.lib.nixosSystem rec {
        system = config.nixosSystem.system;
        modules = config.nixosSystem.modules;
      })) hosts);
      deploy.nodes = (nixpkgs.lib.mapAttrs (name: config: {
        hostname = if (config ? deploy.hostname) then config.deploy.hostname else (self.nixosConfigurations."${name}".config.networking.hostName + "." + self.nixosConfigurations."${name}".config.networking.domain);
        profiles.system = {
          autoRollback = false;
          magicRollback = false;
          user = "root";
          sshUser = "em0lar";
          sshOpts = [ "-4" "-p" "61337" "-o" "StrictHostKeyChecking=no" ];
          path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations."${name}";
        };
      }) hosts);
  };
}
