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
    freyda = {
      nixpkgs = inputs.nixpkgs-unstable;
      configuration = import ./hosts/freyda;
    };
    gaika.configuration = import ./hosts/gaika/configuration.nix;
    kupe.configuration = import ./hosts/kupe/configuration.nix;
    laurel.configuration = import ./hosts/laurel/configuration.nix;
    thia = {
      configuration = import ./hosts/thia/configuration.nix;
      nixpkgs = inputs.nixpkgs-yt;
    };
    turingmachine = {
      nixpkgs = inputs.nixpkgs-unstable;
      configuration = import ./hosts/turingmachine/configuration.nix;
    };
    sphere.configuration = import ./hosts/sphere/configuration.nix;
  };
}
