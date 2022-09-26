{
  description = "leona's NixOS config";

  inputs = {
    nixpkgs-unstable-small.url = "github:NixOS/nixpkgs/nixos-unstable-small";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    leona-is-website = {
      url = "git+https://cyberchaos.dev/leona/leona.is?ref=main";
      inputs.nixpkgs.follows = "nixpkgs-unstable-small";
    };
    dns = {
      url = "github:kirelagin/dns.nix";
      inputs.nixpkgs.follows = "nixpkgs-unstable-small";
    };
    mailserver = {
      url = "gitlab:simple-nixos-mailserver/nixos-mailserver";
      inputs.nixpkgs.follows = "nixpkgs-unstable-small";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs-unstable-small";
    };
  };

  outputs = inputs@{
    self,
    flake-utils,
    dns,
    nixpkgs-unstable-small,
    nixpkgs-unstable,
    home-manager,
    leona-is-website,
    mailserver,
    nixos-hardware,
    sops-nix,
    ...
   }:
    let
      overlays = [
        (final: prev: import ./packages final prev)
        leona-is-website.overlay
      ];

      sourcesModule = {
        _file = ./flake.nix;
        _module.args.inputs = inputs;
      };

      defaultModules = [
        {
          imports = [
            ./modules/backups
            ./modules/bind
            ./modules/nftables
            ./modules/secrets
            ./modules/sops
            ./modules/telegraf
            ./modules/vouch-proxy
            ./modules/grocy
            ./modules/firefly-iii
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
      nixpkgsUnstableSmall = [
        {
          nix.nixPath = nixpkgs-unstable-small.lib.mkDefault [
            "nixpkgs=${nixpkgs-unstable-small}"
            "home-manager=${home-manager}"
          ];
        }
      ];

      hosts = {
        beryl = {
          nixosSystem = {
            system = "x86_64-linux";
            modules = defaultModules ++ nixpkgsUnstableSmall ++ [
              ./hosts/beryl/configuration.nix
            ];
          };
          deployment = {};
        };
        charon = {
          nixosSystem = {
            system = "x86_64-linux";
            modules = defaultModules ++ nixpkgsUnstableSmall ++ [
              ./hosts/charon/configuration.nix
            ];
          };
          deployment = {};
        };
        dwd = {
          nixosSystem = {
            system = "x86_64-linux";
            modules = defaultModules ++ nixpkgsUnstableSmall ++ [
              nixos-hardware.nixosModules.pcengines-apu
              ./hosts/dwd/configuration.nix
            ];
          };
          deployment.targetHost = "10.151.4.1";
          deployment.targetPort = 54973;
        };
        foros = {
          nixosSystem = {
            system = "x86_64-linux";
            modules = defaultModules ++ nixpkgsUnstableSmall ++ [
              ./hosts/foros/configuration.nix
            ];
          };
          deployment = {};
        };
        gaika = {
          nixosSystem = {
            system = "x86_64-linux";
            modules = defaultModules ++ nixpkgsUnstableSmall ++ [
              ./hosts/gaika/configuration.nix
            ];
          };
          deployment.targetHost = "10.151.0.5";
        };
        hack = {
          nixosSystem = {
            system = "x86_64-linux";
            modules = defaultModules ++ nixpkgsUnstableSmall ++ [
              ./hosts/hack/configuration.nix
            ];
          };
          deployment = {};
        };
        haku = {
          nixosSystem = {
            system = "x86_64-linux";
            modules = defaultModules ++ nixpkgsUnstableSmall ++ [
              ./hosts/haku/configuration.nix
            ];
          };
          deployment = {};
        };
        kupe = {
          nixosSystem = {
            system = "x86_64-linux";
            modules = defaultModules ++ nixpkgsUnstableSmall ++ [
              mailserver.nixosModule
              ./modules/imapsync
              ./hosts/kupe/configuration.nix
            ];
          };
          deployment = {};
        };
        ladon = {
          nixosSystem = {
            system = "x86_64-linux";
            modules = defaultModules ++ nixpkgsUnstableSmall ++ [
              ./modules/ory-hydra
              ./hosts/ladon/configuration.nix
            ];
          };
          deployment = {
            targetHost = "2a01:4f9:6a:13c6:4000::f00";
	    targetPort = 54973;
          };
        };
        laurel = {
          nixosSystem = {
            system = "x86_64-linux";
            modules = defaultModules ++ nixpkgsUnstableSmall ++ [
              ./hosts/laurel/configuration.nix
            ];
          };
          deployment = {};
        };
        turingmachine = {
          nixosSystem = {
            system = "x86_64-linux";
            modules = defaultModules ++ [
              nixos-hardware.nixosModules.lenovo-thinkpad-t480s
              ./hosts/turingmachine/configuration.nix
              {
                nix.nixPath = nixpkgs-unstable.lib.mkForce [
                  "nixpkgs=${nixpkgs-unstable}"
                  "home-manager=${home-manager}"
                ];
              }
            ];
          };
          deployment = {
            targetHost = null;
            allowLocalDeployment = true;
          };
        };
        naiad = {
          nixosSystem = {
            system = "x86_64-linux";
            modules = defaultModules ++ nixpkgsUnstableSmall ++ [
              ./hosts/naiad/configuration.nix
            ];
          };
          deployment = {};
        };
        nyan = {
          nixosSystem = {
            system = "x86_64-linux";
            modules = defaultModules ++ nixpkgsUnstableSmall ++ [
              ./hosts/nyan/configuration.nix
            ];
          };
          deployment = {};
        };
      };
    in
    flake-utils.lib.eachDefaultSystem(system:
      let pkgs = nixpkgs-unstable.legacyPackages.${system}; in
      {
        devShell = pkgs.mkShell {
         buildInputs = [
           pkgs.sops
           pkgs.colmena
         ];
       };
      }
    ) // {
      nixosConfigurations = (builtins.mapAttrs (name: config: (nixpkgs-unstable-small.lib.nixosSystem rec {
        system = config.nixosSystem.system;
        modules = config.nixosSystem.modules;
      })) hosts);
      colmena = {
        meta = {
          nixpkgs = import nixpkgs-unstable-small {
            system = "x86_64-linux";
          };
          nodeNixpkgs.turingmachine = import nixpkgs-unstable {
            system = "x86_64-linux";
          };
        };
      } // builtins.mapAttrs (host: config: let
        nixosConfig = self.nixosConfigurations."${host}";
        jsonGroups = builtins.fromJSON (builtins.readFile ./hosts/groups.json);
        groups = builtins.attrNames (nixpkgs-unstable-small.lib.filterAttrs (gname: val: (builtins.elem host val.hosts)) jsonGroups);
      in {
        nixpkgs.system = nixosConfig.config.nixpkgs.system;
        imports = nixosConfig._module.args.modules;
        deployment = {
          tags = groups;
          buildOnTarget = true;
          targetHost = nixosConfig.config.networking.hostName + "." + nixosConfig.config.networking.domain;
          targetUser = "leona";
        } // config.deployment;
      }) (hosts);
  };
}
