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
    deploy-rs.url = "github:serokell/deploy-rs";
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
    deploy-rs,
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
      nixpkgsUnstable = [
        {
          nix.nixPath = nixpkgs-unstable-small.lib.mkDefault [
            "nixpkgs=${nixpkgs-unstable-small}"
            "home-manager=${home-manager}"
          ];
        }
      ];

      hosts = {
        adonis = {
          nixosSystem = {
            system = "aarch64-linux";
            modules = defaultModules ++ nixpkgsUnstable ++ [
              ./hosts/adonis/configuration.nix
            ];
          };
        };
        beryl = {
          nixosSystem = {
            system = "x86_64-linux";
            modules = defaultModules ++ nixpkgsUnstable ++ [
              ./hosts/beryl/configuration.nix
            ];
          };
        };
        cole = {
          nixosSystem = {
            system = "aarch64-linux";
            modules = defaultModules ++ nixpkgsUnstable ++ [
              ./hosts/cole/configuration.nix
            ];
          };
          deploy.hostname = "fd8f:d15b:9f40:10:ba27:ebff:fe5d:d0af";
        };
        dwd = {
          nixosSystem = {
            system = "x86_64-linux";
            modules = defaultModules ++ nixpkgsUnstable ++ [
              nixos-hardware.nixosModules.pcengines-apu
              ./hosts/dwd/configuration.nix
            ];
          };
          deploy.hostname = "dwd.wg.net.leona.is";
        };
        foros = {
          nixosSystem = {
            system = "x86_64-linux";
            modules = defaultModules ++ nixpkgsUnstable ++ [
              ./modules/firefly-iii
              ./hosts/foros/configuration.nix
            ];
          };
        };
        hack = {
          nixosSystem = {
            system = "x86_64-linux";
            modules = defaultModules ++ nixpkgsUnstable ++ [
              ./hosts/hack/configuration.nix
            ];
          };
        };
        haku = {
          nixosSystem = {
            system = "x86_64-linux";
            modules = defaultModules ++ nixpkgsUnstable ++ [
              ./hosts/haku/configuration.nix
            ];
          };
        };
        kupe = {
          nixosSystem = {
            system = "x86_64-linux";
            modules = defaultModules ++ nixpkgsUnstable ++ [
              mailserver.nixosModule
              ./modules/imapsync
              ./hosts/kupe/configuration.nix
            ];
          };
        };
        ladon = {
          nixosSystem = {
            system = "x86_64-linux";
            modules = defaultModules ++ nixpkgsUnstable ++ [
              ./modules/ory-hydra
              ./hosts/ladon/configuration.nix
            ];
          };
        };
        laurel = {
          nixosSystem = {
            system = "x86_64-linux";
            modules = defaultModules ++ nixpkgsUnstable ++ [
              ./hosts/laurel/configuration.nix
            ];
          };
          deploy.hostname = "laurel.wg.net.leona.is";
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
          deploy.hostname = "fd8f:d15b:9f40:10:8e16:45ff:fe89:d164";
        };
        naiad = {
          nixosSystem = {
            system = "x86_64-linux";
            modules = defaultModules ++ nixpkgsUnstable ++ [
              ./hosts/naiad/configuration.nix
            ];
          };
        };
        nyan = {
          nixosSystem = {
            system = "x86_64-linux";
            modules = defaultModules ++ nixpkgsUnstable ++ [
              ./hosts/nyan/configuration.nix
            ];
          };
        };
      };
    in
    flake-utils.lib.eachDefaultSystem(system:
      let pkgs = nixpkgs-unstable.legacyPackages.${system}; in
      {
        devShell = pkgs.mkShell {
         buildInputs = [
           pkgs.sops
         ];
       };
      }
    ) // {
      nixosConfigurations = (nixpkgs-unstable-small.lib.mapAttrs (name: config: (nixpkgs-unstable-small.lib.nixosSystem rec {
        system = config.nixosSystem.system;
        modules = config.nixosSystem.modules;
      })) hosts);
      deploy.nodes = (nixpkgs-unstable-small.lib.mapAttrs (name: config: {
        hostname = if (config ? deploy.hostname) then config.deploy.hostname else (self.nixosConfigurations."${name}".config.networking.hostName + "." + self.nixosConfigurations."${name}".config.networking.domain);
        profiles.system = {
          autoRollback = false;
	        magicRollback = false;
          user = "root";
          sshUser = "leona";
          sshOpts = [ "-o" "StrictHostKeyChecking=no" ];
          path = deploy-rs.lib.${config.nixosSystem.system}.activate.nixos self.nixosConfigurations."${name}";
        };
      }) hosts);
  };
}
