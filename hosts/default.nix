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
        meta = rec {
          nixpkgs = import inputs.nixpkgs {
            system = "x86_64-linux";
          };

          nodeNixpkgs = lib.genAttrs [ "bij" "laurel" "sphere" ]
            (_: import inputs.nixpkgs {
              system = "aarch64-linux";
            }) // lib.genAttrs [ "freyda" "thia" "turingmachine" ]
            (_: import inputs.nixpkgs-unstable {
              system = "x86_64-linux";
            }) // {
              enari = (import
                ((import inputs.nixpkgs { system = "x86_64-linux"; }).applyPatches {
                  name = "nixpkgs-patched-enari";
                  src = inputs.nixpkgs;
                  patches = [
                    (nixpkgs.fetchpatch {
                      url = "https://github.com/leona-ya/nixpkgs/commit/058adef892aa562a500823954ef179ffb9b73d71.patch";
                      hash = "sha256-zO3yPoxMUnMUrBFjpQZUX9hLJo/1bvQbLaoo+I2v4Ow=";
                    })
                  ];
                })
                { system = "x86_64-linux"; });
              thia = (import
                ((import inputs.nixpkgs { system = "x86_64-linux"; }).applyPatches {
                  name = "nixpkgs-patched-thia";
                  src = inputs.nixpkgs;
                  patches = [
                  ];
                })
                { system = "x86_64-linux"; });
              naya = (import
                ((import inputs.nixpkgs { system = "x86_64-linux"; }).applyPatches {
                  name = "nixpkgs-patched-naya";
                  src = inputs.nixpkgs;
                  patches = [
                  ];
                })
                { system = "x86_64-linux"; });
              sphere = (import
                ((import inputs.nixpkgs { system = "x86_64-linux"; }).applyPatches {
                  name = "nixpkgs-patched-sphere";
                  src = inputs.nixpkgs;
                  patches = [
                  ];
                })
                { system = "aarch64-linux"; });
          };

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
