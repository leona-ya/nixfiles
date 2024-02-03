{
  description = "leona's NixOS config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable-small";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-thia.url = "github:leona-ya/nixpkgs/nixos-unstable-thia";
    nixpkgs-yt.url = "github:leona-ya/nixpkgs/youtrack-warn-fix";
    ccc-nixlib = {
      url = "gitlab:cyberchaoscreatures/nixlib/main?host=cyberchaos.dev";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur.url = "github:nix-community/NUR";
    flake-utils.url = "github:numtide/flake-utils";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    leona-is-website = {
      url = "git+https://cyberchaos.dev/leona/leona.is?ref=main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dns = {
      url = "github:kirelagin/dns.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    mailserver = {
      url = "gitlab:dotlambda/nixos-mailserver/sieve-fix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    colmena = {
      url = "github:zhaofengli/colmena/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs: {
    suxin = inputs.ccc-nixlib.suxinSystem {
      modules = [
        ./nodes.nix
      ];
      specialArgs = { inherit inputs; };
    };
    inherit (inputs.self.suxin.config) nixosConfigurations colmenaHive;

    overlays = {
      colmena = inputs.colmena.overlay;
      leona-is-website = inputs.leona-is-website.overlay;
      inherit (inputs.ccc-nixlib.overlays) pleroma;
      default = import ./packages;
      iso = final: prev: {
        iso = (inputs.nixpkgs.lib.nixosSystem {
          system = final.stdenv.targetPlatform.system;
          specialArgs = {
            inputs = inputs;
            nixpkgs = inputs.nixpkgs;
          };
          modules = [
            (import ./lib/iso.nix)
          ];
        }).config.system.build.isoImage;
      };
    };

    nixosModules = {
      sops = import ./modules/sops;
      telegraf = import ./modules/telegraf;
      leona-profile = import ./users/leona/importable.nix;
    };

  } // inputs.flake-utils.lib.eachDefaultSystem(system:
    let
      nixpkgs = import inputs.nixpkgs {
        inherit system;
        overlays = inputs.nixpkgs.lib.attrValues inputs.self.overlays;
      };
      pkgs = inputs.nixpkgs.legacyPackages.${system};
     in {
       devShell = pkgs.mkShell {
         buildInputs = [
           pkgs.sops
           pkgs.colmena
         ];
       };
       legacyPackages = nixpkgs;
     });
}
