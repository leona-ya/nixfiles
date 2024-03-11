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
              thia = (import ((import inputs.nixpkgs-unstable { system = "x86_64-linux"; }).applyPatches {
                name = "nixpkgs-patched-293864";
                src = inputs.nixpkgs-unstable;
                patches = [
                  (nixpkgs.fetchpatch {
                    url = "https://github.com/NixOS/nixpkgs/pull/293864/commits/91ae595ff875ae0106e5d375acbc809daaf03115.patch";
                    hash = "sha256-2iojVOPgtYzX7czwSGb5gR3GTsuXbDs1paNz8D3WU+0=";
                  })
                ];
              }) { system = "x86_64-linux"; });
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
