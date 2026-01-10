{ inputs, self, ... }:
{
  flake = {
    colmenaHive = inputs.colmena.lib.makeHive self.outputs.colmena;
    colmena =
      let
        inherit (inputs.nixpkgs) lib;

        isDir = _name: type: type == "directory";

        hostDirs = builtins.attrNames (lib.filterAttrs isDir (builtins.readDir ./.));

        # improve when l.meta is available
        linuxHosts = lib.genAttrs (builtins.filter (h: h != "amphion") hostDirs) (name: {
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

          nodeNixpkgs =
            lib.genAttrs [ "ceto" "freyda" "turingmachine" ] (
              _:
              import inputs.nixpkgs-unstable {
                system = "x86_64-linux";
              }
            )
            // lib.genAttrs [ "moka" ] (
              _:
              import inputs.nixpkgs-2511 {
                system = "x86_64-linux";
              }
            )
            // rec {
              neris = (
                import ((import inputs.nixpkgs { system = "x86_64-linux"; }).applyPatches {
                  name = "nixpkgs-patched-neris";
                  src = inputs.nixpkgs;
                  patches = [
                    (nixpkgs.fetchpatch {
                      url = "https://github.com/nixos/nixpkgs/commit/437436773894b69babca8d6864a7a9a1965925de.patch";
                      hash = "sha256-kLHQpprB+9HQOt1tUoHvdCtLB5K++asvFLEjOwr3fzE=";
                    })
                    (nixpkgs.fetchpatch {
                      url = "https://github.com/leona-ya/nixpkgs/commit/0cf640ccac2e111d7981b716557977dd23a4562b.patch";
                      hash = "sha256-XlnRTMUpe9kJXKZkFFaJ7bA/AuFUgbq6MRiWKg9xGyc=";
                    })
                  ];
                }) { system = "x86_64-linux"; }
              );
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
      }
      // linuxHosts;

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
    };
  };
}
