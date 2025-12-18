{ self, lib, inputs, ... }:
rec {

  flake.overlays.default =
    final: prev:
    let
      pseudoPkgs = (perSystem { pkgs = { }; }).packages;
    in
    builtins.mapAttrs (name: _: self.packages.${final.stdenv.hostPlatform.system}.${name}) pseudoPkgs;

  perSystem =
    { pkgs, ... }:
    {
      packages = {
        opendatamap-net = pkgs.callPackage ./opendatamap-net { };
        legitima = pkgs.callPackage ./legitima { };
        cups-brother-ptouch = pkgs.callPackage ./cups-brother-ptouch { };
        questrial-regular = pkgs.callPackage ./questrial { };
        #jetbrains-jdk-21 = pkgs.callPackage ./jetbrains-jdk-21;
        #gimp = pkgs.callPackage ./gimp {};
        annieuseyourtelescope = pkgs.callPackage ./annieuseyourtelescope { };
        pleroma-fe = pkgs.callPackage ./pleroma-fe { };
        iso = (self.inputs.nixpkgs.lib.nixosSystem {
          system = pkgs.stdenv.targetPlatform.system;
          specialArgs = {
            inputs = inputs;
            nixpkgs = inputs.nixpkgs;
          };
          modules = [
            (import ../lib/iso.nix)
          ];
        }).config.system.build.isoImage;
        waterfox = pkgs.callPackage ./waterfox { };
      };
    };
}
