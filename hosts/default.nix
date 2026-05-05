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
            inputs.home-manager-2511.nixosModules.home-manager
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
                      url = "https://github.com/NixOS/nixpkgs/pull/514527.patch";
                      hash = "sha256-0xn/2QGrNUy75R5u2D+dEE7/zPEVkzINn+92E6AzNl0=";
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
                      hash = "sha256-NfbyX7fwd+O2u1v7Fl35pvq0MDPqj/YwRG8OvJS3oXI=";
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
