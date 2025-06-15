{ inputs, self, ... }:
{
  flake = {
    colmenaHive = inputs.colmena.lib.makeHive self.outputs.colmena;
    colmena =
      let
        inherit (inputs.nixpkgs) lib;

        isDir = _name: type: type == "directory";

        hostDirs = builtins.attrNames
          (lib.filterAttrs isDir
            (builtins.readDir ./.)
          );

        # improve when l.meta is available
        linuxHosts = lib.genAttrs (builtins.filter (h: h != "mydon" && h!= "amphion") hostDirs) (name: {
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
            }) // lib.genAttrs [ "ceto" "freyda" "thia" "turingmachine" ]
            (_: import inputs.nixpkgs-unstable {
              system = "x86_64-linux";
            }) // rec {
              enari = (import
                ((import inputs.nixpkgs { system = "x86_64-linux"; }).applyPatches {
                  name = "nixpkgs-patched-enari";
                  src = inputs.nixpkgs;
                  patches = [
                  ];
                })
                { system = "x86_64-linux"; });
              kupe = enari;
              ceto = (import
                ((import inputs.nixpkgs { system = "x86_64-linux"; }).applyPatches {
                  name = "nixpkgs-patched-ceto";
                  src = inputs.nixpkgs;
                  patches = [
                    (nixpkgs.fetchpatch {
                      url = "https://github.com/nixos/nixpkgs/pull/411792.patch";
                      hash = "sha256-j0+k2WxxcBlkeQtr9uPZzUyI2ArZh6E8Nd0fnz/jiac=";
                    })
                  ];
                })
                { system = "x86_64-linux"; });
              freyda = ceto;
              naya = (import
                ((import inputs.nixpkgs { system = "x86_64-linux"; }).applyPatches {
                  name = "nixpkgs-patched-naya";
                  src = inputs.nixpkgs;
                  patches = [
                    (nixpkgs.fetchpatch {
                      url = "https://github.com/leona-ya/nixpkgs/commit/83030f0848aacf411f81a7a95cd0b812664d3bbb.patch";
                      hash = "sha256-T7v0XLWGTBU6h/jzaaz0fxIDJ+Wzm4uIgOBjwU4IRd4=";
                    })
                    (nixpkgs.fetchpatch {
                      url = "https://github.com/leona-ya/nixpkgs/commit/762941c4e0450ba8418c6803601dd2acf046c6e7.patch";
                      hash = "sha256-JNnxLN4CZHBUAK6epnz8b3Pv0M5uOJa9SV8l0IQkqTE=";
                    })
                  ];
                })
                { system = "x86_64-linux"; });
              laurel = (import
                ((import inputs.nixpkgs { system = "x86_64-linux"; }).applyPatches {
                  name = "nixpkgs-patched-laurel";
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
            ../profiles/base-nixos
          ];
        };
      } // linuxHosts;

    nixosConfigurations = (inputs.colmena.lib.makeHive self.outputs.colmena).nodes;
    darwinConfigurations = {
      amphion = inputs.darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [ 
          ../profiles/base
          ../profiles/darwin
          ./amphion 
        ];        
        specialArgs = {
          inherit inputs;
        };
      };
      mydon = inputs.darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [
          ../profiles/base
          ../profiles/darwin
          ./mydon
        ];
        specialArgs = {
          inherit inputs;
        };
      };
    };
  };
}
