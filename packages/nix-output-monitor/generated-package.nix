# This file has been autogenerate with cabal2nix.
# Update via ./update.sh"
{
  mkDerivation,
  ansi-terminal,
  async,
  attoparsec,
  base,
  bytestring,
  cassava,
  containers,
  directory,
  extra,
  fetchzip,
  filelock,
  filepath,
  hermes-json,
  HUnit,
  lib,
  nix-derivation,
  optics,
  random,
  relude,
  safe,
  safe-exceptions,
  stm,
  streamly-core,
  strict,
  terminal-size,
  text,
  time,
  transformers,
  typed-process,
  unix,
  word8,
}:
mkDerivation {
  pname = "nix-output-monitor";
  version = "2.1.8";
  src = fetchzip {
    url = "https://code.maralorn.de/maralorn/nix-output-monitor/archive/ea3731cbb921dc728ed611614f542fd6b76d4524.tar.gz";
    sha256 = "1gy7qh0c003j9wmrvmbrq3axsqpplv7l93dcfwpkahc7ykjr7k8p";
  };
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [
    ansi-terminal
    async
    attoparsec
    base
    bytestring
    cassava
    containers
    directory
    extra
    filelock
    filepath
    hermes-json
    nix-derivation
    optics
    relude
    safe
    safe-exceptions
    stm
    streamly-core
    strict
    terminal-size
    text
    time
    transformers
    word8
  ];
  executableHaskellDepends = [
    ansi-terminal
    async
    attoparsec
    base
    bytestring
    cassava
    containers
    directory
    extra
    filelock
    filepath
    hermes-json
    nix-derivation
    optics
    relude
    safe
    safe-exceptions
    stm
    streamly-core
    strict
    terminal-size
    text
    time
    transformers
    typed-process
    unix
    word8
  ];
  testHaskellDepends = [
    ansi-terminal
    async
    attoparsec
    base
    bytestring
    cassava
    containers
    directory
    extra
    filelock
    filepath
    hermes-json
    HUnit
    nix-derivation
    optics
    random
    relude
    safe
    safe-exceptions
    stm
    streamly-core
    strict
    terminal-size
    text
    time
    transformers
    typed-process
    word8
  ];
  homepage = "https://code.maralorn.de/maralorn/nix-output-monitor";
  description = "Processes output of Nix commands to show helpful and pretty information";
  license = lib.licensesSpdx."EUPL-1.2";
  mainProgram = "nom";
  maintainers = [ lib.maintainers.maralorn ];
}
