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
            }) // rec {
              enari = (import
                ((import inputs.nixpkgs { system = "x86_64-linux"; }).applyPatches {
                  name = "nixpkgs-patched-enari";
                  src = inputs.nixpkgs;
                  patches = [
                    (nixpkgs.fetchpatch {
                      url = "https://github.com/NixOS/nixpkgs/pull/359329.patch";
                      hash = "sha256-UaM1PMKw7MGQR01IejibqqqXPGfyRZrRjNWQH9EcR3A=";
                    })
                  ];
                })
                { system = "x86_64-linux"; });
              thia = (import
                ((import inputs.nixpkgs { system = "x86_64-linux"; }).applyPatches {
                  name = "nixpkgs-patched-thia";
                  src = inputs.nixpkgs-unstable;
                  patches = [
                    (nixpkgs.fetchpatch {
                      url = "https://github.com/NixOS/nixpkgs/pull/357916.patch";
                      hash = "sha256-cRlmuekU6uogQRKAu/AJMz7fVsbTe4p9AW5hr76DjC0=";
                    })
                  ];
                })
                { system = "x86_64-linux"; });
              freyda = thia;
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
