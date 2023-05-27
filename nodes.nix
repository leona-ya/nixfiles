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
    gaika.configuration = import ./hosts/gaika/configuration.nix;
    kupe.configuration = import ./hosts/kupe/configuration.nix;
    ladon.configuration = import ./hosts/ladon/configuration.nix;
    thia = {
      configuration = import ./hosts/thia/configuration.nix;
      nixpkgs = inputs.nixpkgs-unstable;
    };
    turingmachine = {
      configuration = import ./hosts/turingmachine/configuration.nix;
      nixpkgs = inputs.nixpkgs-unstable;
    };
    naiad.configuration = import ./hosts/naiad/configuration.nix;
  };
}
