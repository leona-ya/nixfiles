{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "questrial-regular";
  version = "1.0";

  src = fetchurl {
    url = "https://events.ccc.de/camp/2023/infos/styleguide/v3/Fonts/Typo_for_running-text/Questrial-Regular.ttf";
    sha256 = "0kpmjjxwzm84z8maz6lq9sk1b0xv1zkvl28lwj7i0m2xf04qixd1";
  };

  dontUnpack = true;

  installPhase = ''
    install -D -m 0644 $src $out/share/fonts/truetype/Questrial-Regular.ttf
  '';
}
