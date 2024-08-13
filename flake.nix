{
  description = "leona's NixOS config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable-small";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.91.0.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ccc-nixlib = {
      url = "gitlab:cyberchaoscreatures/nixlib/main?host=cyberchaos.dev";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur.url = "github:nix-community/NUR";
    flake-parts.url = "github:hercules-ci/flake-parts";
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
      url = "gitlab:simple-nixos-mailserver/nixos-mailserver";
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
    lanzaboote = {
      url = "github:nix-community/lanzaboote/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } {
    systems = [ "x86_64-linux" "aarch64-linux" ];
    imports = [
      ./hosts
      ./packages
    ];
    flake = {
      overlays = {
        colmena = inputs.colmena.overlay;
        leona-is-website = inputs.leona-is-website.overlay;
        inherit (inputs.ccc-nixlib.overlays) pleroma;
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
    };
    perSystem = { config, pkgs, inputs', self', system, ... }: {
      formatter = pkgs.nixpkgs-fmt;
      devShells.default = pkgs.mkShellNoCC {
        buildInputs = [
          pkgs.sops
          pkgs.colmena
        ];
      };
    };
  };
}
