{ pkgs, stdenv, lib, fetchFromGitHub, dataDir ? "/var/lib/firefly-iii" }:

let
  package = (import ./composition.nix {
    inherit pkgs;
    inherit (stdenv.hostPlatform) system;
    noDev = true; # Disable development dependencies
  }).overrideAttrs (attrs : {
    installPhase = attrs.installPhase + ''
      rm -R $out/storage
      ln -s ${dataDir}/.env $out/.env
      ln -s ${dataDir}/storage $out/storage
    '';
  });

in package.override rec {
  pname = "firefly-iii";
  version = "5.7.9";

  src = fetchFromGitHub {
    owner = "firefly-iii";
    repo = "firefly-iii";
    rev = "${version}";
    sha256 = "101nqpn0wiwpv6pggb9ac7psh7xp30isyx8cvb596mj6vbzaa7i4";
  };

  meta = with lib; {
    description = "A personal finances manager";
    homepage = "https://www.firefly-iii.org/";
    license = licenses.agpl3;
    maintainers = with maintainers; [ leona ];
    platforms = platforms.linux;
  };
}
