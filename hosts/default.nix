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

        # improve when l.meta is available
        linuxHosts = lib.genAttrs (builtins.filter (h: h != "mydon") hostDirs) (name: {
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
                      url = "https://github.com/NixOS/nixpkgs/pull/371838.patch";
                      hash = "sha256-pQXRm9U0CxiafATibf4OmiBw+wIZw6pd20iGBOYN+Cg=";
                    })
                  ];
                })
                { system = "x86_64-linux"; });
              thia = (import
                ((import inputs.nixpkgs { system = "x86_64-linux"; }).applyPatches {
                  name = "nixpkgs-patched-thia";
                  src = inputs.nixpkgs-unstable;
                  patches = [
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
            ../profiles/base-nixos
          ];
        };
      } // linuxHosts;

    nixosConfigurations = (inputs.colmena.lib.makeHive self.outputs.colmena).nodes;
    darwinConfigurations = {
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
