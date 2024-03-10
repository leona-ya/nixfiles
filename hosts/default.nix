{ inputs, self, ... }:
{
  flake = {
    colmena =
      let
        inherit (inputs.nixpkgs) lib;

        isDir = _name: type: type == "directory";

        hostDirs = builtins.attrNames
          (lib.filterAttrs isDir
            (builtins.readDir ./.)
          );

        hosts = lib.genAttrs hostDirs (name: {
          imports = [
            (./. + "/${name}")
          ];
        });

      in
      {
        meta = {
          nixpkgs = import inputs.nixpkgs {
            system = "x86_64-linux";
          };

          nodeNixpkgs = lib.genAttrs [ "bij" "laurel" "sphere" ]
            (_: import inputs.nixpkgs {
              system = "aarch64-linux";
          }) // lib.genAttrs [ "freyda" "thia" "turingmachine" ]
            (_: import inputs.nixpkgs-unstable {
              system = "x86_64-linux";
            });

          specialArgs = {
            inherit inputs;
          };
        };

        defaults = {
          imports = [
            ../profiles/base
          ];
        };
      } // hosts;

    nixosConfigurations = (inputs.colmena.lib.makeHive self.outputs.colmena).nodes;
  };
}
