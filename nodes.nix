{ lib, inputs, ... }:

{
  defaults = {
    specialArgs = { inherit inputs; };
    nixpkgs = lib.mkDefault inputs.nixpkgs;
    configuration = import ./profiles/base;
  };

  nodes = {
    bij.configuration = import ./hosts/bij/configuration.nix;
    dwd.configuration = import ./hosts/dwd/configuration.nix;
    enari.configuration = import ./hosts/enari/configuration.nix;
    gaika.configuration = import ./hosts/gaika/configuration.nix;
    kupe.configuration = import ./hosts/kupe/configuration.nix;
    laurel.configuration = import ./hosts/laurel/configuration.nix;
    naiad.configuration = import ./hosts/naiad/configuration.nix;
    thia = {
      configuration = import ./hosts/thia/configuration.nix;
      nixpkgs = inputs.nixpkgs-unstable;
    };
    turingmachine = let
      nixpkgs = (import inputs.nixpkgs { system = "x86_64-linux"; }).applyPatches {
        name = "nixpkgs-patched-turingmchine";
        src = inputs.nixpkgs;
        patches = [ ./yt-test.patch ];
      };
    in {
      configuration = import ./hosts/turingmachine/configuration.nix;
      nixpkgs = nixpkgs;
    };
    sphere.configuration = import ./hosts/sphere/configuration.nix;
    sphere.nixpkgs = inputs.nixpkgs-sphere;
  };
}
