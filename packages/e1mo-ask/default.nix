{ stdenv, fetchFromGitHub, writeText, config ? "" }:

let
  configFile = writeText "config.php" config;
in stdenv.mkDerivation rec {
  pname = "e1mo-ask";
  version = "2.0.3";

  src = fetchFromGitHub {
    owner = "e1mo";
    repo = "ask.e1mo.de";
    rev = "v${version}";
    sha256 = "Y/d6GN9ZmJ40L5EMggFpsx/9JMgwv9bYzlE9xtk2rQU=";
    fetchSubmodules = true;
  };

  installPhase =
  ''
    mkdir -p $out
    cp -r * $out/
    ln -s ${configFile} $out/config.php
  '';
}
