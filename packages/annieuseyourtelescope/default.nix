{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "annieuseyourtelescope";
  version = "1.0";

  src = ./AnnieUseYourTelescope-Regular.ttf;
  dontUnpack = true;

  installPhase = ''
    install -D -m 0644 $src $out/share/fonts/truetype/AnnieUseYourTelescope-Regular.ttf
  '';
}
