{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "questrial-regular";
  version = "1.0";

  src = fetchurl {
    url = "https://events.ccc.de/camp/2023/infos/styleguide/v3/Fonts/Typo_for_running-text/Questrial-Regular.ttf";
    sha256 = "sha256-ghsQNm62t5RcmfTVFS4e0Z5Exb/vv2eWb6bxq52s/hU=";
  };

  dontUnpack = true;

  installPhase = ''
    install -D -m 0644 $src $out/share/fonts/truetype/Questrial-Regular.ttf
  '';
}
