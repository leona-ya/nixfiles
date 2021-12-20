{
  description = "em0lar's NixOS config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
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
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{
    self,
    flake-utils,
    dns,
    nixpkgs,
    home-manager,
    flake-registry,
    deploy-rs,
    em0lar-dev-website,
    mailserver,
    nixos-hardware,
    sops-nix,
    ...
   }:
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
            ./modules/sops
            ./modules/telegraf
            ./modules/vouch-proxy
          ];
          documentation.info.enable = false;
        }
        home-manager.nixosModules.home-manager
        {
          nixpkgs.overlays = overlays;
        }
        sourcesModule
        sops-nix.nixosModules.sops
      ];

      hosts = {
        adonis = {
          nixosSystem = {
            system = "aarch64-linux";
            modules = defaultModules ++ [
              ./hosts/adonis/configuration.nix
            ];
          };
        };
        aido = {
          nixosSystem = {
            system = "x86_64-linux";
            modules = defaultModules ++ [
              ./hosts/aido/configuration.nix
            ];
          };
          deploy.hostname = "aido.lan";
        };
        beryl = {
          nixosSystem = {
            system = "x86_64-linux";
            modules = defaultModules ++ [
              ./hosts/beryl/configuration.nix
            ];
          };
        };
        cole = {
          nixosSystem = {
            system = "aarch64-linux";
            modules = defaultModules ++ [
              ./hosts/cole/configuration.nix
            ];
          };
          deploy.hostname = "fd8f:d15b:9f40:10:ba27:ebff:fe5d:d0af";
        };
        dwd = {
          nixosSystem = {
            system = "x86_64-linux";
            modules = defaultModules ++ [
              nixos-hardware.nixosModules.pcengines-apu
              ./hosts/dwd/configuration.nix
            ];
          };
          deploy.hostname = "dwd.lan";
        };
        foros = {
          nixosSystem = {
            system = "x86_64-linux";
            modules = defaultModules ++ [
              ./hosts/foros/configuration.nix
            ];
          };
        };
        haku = {
          nixosSystem = {
            system = "x86_64-linux";
            modules = defaultModules ++ [
              ./hosts/haku/configuration.nix
            ];
          };
        };
        kupe = {
          nixosSystem = {
            system = "x86_64-linux";
            modules = defaultModules ++ [
              mailserver.nixosModule
              ./hosts/kupe/configuration.nix
            ];
          };
        };
        ladon = {
          nixosSystem = {
            system = "x86_64-linux";
            modules = defaultModules ++ [
              ./hosts/ladon/configuration.nix
            ];
          };
          deploy.hostname = "ladon.wg.net.em0lar.dev";
        };
        turingmachine = {
          nixosSystem = {
            system = "x86_64-linux";
            modules = defaultModules ++ [
              nixos-hardware.nixosModules.lenovo-thinkpad-t480s
              ./hosts/turingmachine/configuration.nix
            ];
          };
          deploy.hostname = "turingmachine.lan";
        };
        naiad = {
          nixosSystem = {
            system = "x86_64-linux";
            modules = defaultModules ++ [
              ./hosts/naiad/configuration.nix
            ];
          };
        };
        nyo = {
          nixosSystem = {
            system = "x86_64-linux";
            modules = defaultModules ++ [
              ./hosts/nyo/configuration.nix
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
          deploy.hostname = "188.34.167.131";
        };
      };
    in
    flake-utils.lib.eachDefaultSystem(system:
      let pkgs = nixpkgs.legacyPackages.${system}; in
      {
        devShell = pkgs.mkShell {
         buildInputs = [
           pkgs.sops
         ];
       };
      }
    ) // {
      nixosConfigurations = (nixpkgs.lib.mapAttrs (name: config: (nixpkgs.lib.nixosSystem rec {
        system = config.nixosSystem.system;
        modules = config.nixosSystem.modules;
      })) hosts);
      deploy.nodes = (nixpkgs.lib.mapAttrs (name: config: {
        hostname = if (config ? deploy.hostname) then config.deploy.hostname else (self.nixosConfigurations."${name}".config.networking.hostName + "." + self.nixosConfigurations."${name}".config.networking.domain);
        profiles.system = {
          autoRollback = false;
          user = "root";
          sshUser = "em0lar";
          sshOpts = [ "-o" "StrictHostKeyChecking=no" "-p" "61337" ];
          path = deploy-rs.lib.${config.nixosSystem.system}.activate.nixos self.nixosConfigurations."${name}";
        };
      }) hosts);
  };
}
