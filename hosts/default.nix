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
                  src = inputs.nixpkgs-unstable;
                  patches = [
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
                      url = "https://github.com/leona-ya/nixpkgs/commit/69f5b8d40fe18f4b709dc23cddacf60e07217222.patch";
                      hash = "sha256-rkRxHCzd/wDvZ6NOsKeIAinz1AUXlq2yztOL/sK0ek4=";
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
