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
          ]
          ++ lib.optionals (name != "moka") [
            inputs.home-manager.nixosModules.home-manager
          ]
          ++ lib.optionals (name == "moka") [
            inputs.home-manager-2605.nixosModules.home-manager
          ];
        });
        fetchpatch =
          (import inputs.nixpkgs {
            system = "x86_64-linux";
          }).fetchpatch;
      in
      {
        meta = rec {
          nixpkgs = import inputs.nixpkgs {
            system = "x86_64-linux";
          };
          nodeNixpkgs =
            lib.genAttrs [ "ceto" "freyda" "thizy" ] (
              _:
              import inputs.nixpkgs-unstable {
                system = "x86_64-linux";
              }
            )
            // lib.genAttrs [ "moka" ] (
              _:
              import inputs.nixpkgs-2605 {
                system = "x86_64-linux";
              }
            )
            // {
              laurake = import (
                (import inputs.nixpkgs {
                  system = "x86_64-linux";
                }).applyPatches
                {
                  name = "nixpkgs-patched";
                  src = inputs.nixpkgs;
                  patches = [
                    (fetchpatch {
                      url = "https://github.com/NixOS/nixpkgs/pull/531004.patch";
                      hash = "sha256-vC6u4whytqBlYuwDb4CzltbiAOKel4RIYUD8xYsztwk=";
                    })
                  ];
                }
              ) { system = "x86_64-linux"; };
              thia = import (
                (import inputs.nixpkgs {
                  system = "x86_64-linux";
                }).applyPatches
                {
                  name = "nixpkgs-patched";
                  src = inputs.nixpkgs;
                  patches = [
                    (fetchpatch {
                      url = "https://github.com/NixOS/nixpkgs/pull/515100.patch";
                      hash = "sha256-Vl5zodjDCsaPa6O15+2m9oOqhxzL1lY31MfGuzjsyHg=";
                    })
                  ];
                }
              ) { system = "x86_64-linux"; };
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
