{ pkgs, stdenv, lib, fetchFromGitHub, dataDir ? "/var/lib/firefly-iii/data-importer" }:

let
  package = (import ./composition.nix {
    inherit pkgs;
    inherit (stdenv.hostPlatform) system;
    noDev = true; # Disable development dependencies
  }).overrideAttrs (attrs: {
    installPhase = attrs.installPhase + ''
      rm -R $out/storage
      ln -s ${dataDir}/.env $out/.env
      ln -s ${dataDir}/storage $out/storage
    '';
  });

in
package.override rec {
  pname = "firefly-iii-data-importer";
  version = "0.9.10";

  src = fetchFromGitHub {
    owner = "firefly-iii";
    repo = "data-importer";
    rev = "${version}";
    sha256 = "0bc9ww75lmdgy2qqmj5f6gz0ghl1fc58598hsmrns8v7qm58cflz";
  };

  meta = with lib; {
    description = "The Firefly III Data Importer can import data into Firefly III";
    homepage = "https://github.com/firefly-iii/data-importer";
    license = licenses.agpl3;
    maintainers = with maintainers; [ leona ];
    platforms = platforms.linux;
  };
}
