{
  fetchFromGitHub,
  lib,
  bundlerEnv,
  stdenv,
  ruby,
}:

let
  build-env = bundlerEnv {
    name = "opendatamap-net-build-env";
    gemfile = ./Gemfile;
    lockfile = ./Gemfile.lock;
    gemset = ./gemset.nix;
    ruby = ruby;
  };
in
stdenv.mkDerivation rec {
  pname = "opendatamap-net";
  version = "main";
  buildInputs = [ build-env ];
  buildPhase = "jekyll build -d $out";
  dontInstall = true;
  src = fetchFromGitHub {
    owner = "opendatamap";
    repo = "opendatamap.net";
    rev = "b97b98074ecc45debaa19fd5d445cdf9aa8b9396";
    sha256 = "RYAUIPysNPPfoHnNWK2xSi5D/0dU8Fnh2y/2v70JuWs=";
  };
}
