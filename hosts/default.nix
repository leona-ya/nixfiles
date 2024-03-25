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
              laurel = (import ((import inputs.nixpkgs-unstable { system = "x86_64-linux"; }).applyPatches {
                name = "nixpkgs-patched-laurel";
                src = inputs.nixpkgs-unstable;
                patches = [
                  (nixpkgs.fetchpatch {
                    url = "https://github.com/NixOS/nixpkgs/pull/296657.patch";
                    hash = "sha256-3LePoEPxYNFYqtMuicmjEmAeCGqFGWBQbnEOU5JsJlM=";
                  })
                ];
              }) { system = "aarch64-linux"; });

              thia = (import ((import inputs.nixpkgs-unstable { system = "x86_64-linux"; }).applyPatches {
                name = "nixpkgs-patched-thia";
                src = inputs.nixpkgs-unstable;
                patches = [
                  (nixpkgs.fetchpatch {
                    url = "https://github.com/NixOS/nixpkgs/pull/297279.patch";
                    hash = "sha256-gKhQBZMRjtFvl4Q7vor0l29/Y7F1MWdx4FLvfC4QyJg=";
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
