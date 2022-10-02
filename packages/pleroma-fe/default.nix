{ fetchFromGitLab, fetchYarnDeps, stdenv, fixup_yarn_lock, yarn, nodejs, substituteAll }:

stdenv.mkDerivation rec {
  pname = "pleroma-fe";
  version = "develop";

  src = fetchFromGitLab {
    domain = "git.pleroma.social";
    owner = "pleroma";
    repo = pname;
    rev = "a6134471055935dcbb94d9b2ed69dc8c2cf57832";
    sha256 = "sha256-0un7dMXRAOhDGwCkD4e9YpftQDteXXuUhXuphSu9cz4=";
  };

  patches = [
    (substituteAll {
      src = ./git-rev.diff;
      inherit (src) rev;
    })
    ./manifest.diff
    ./replies-in-timeline-following.diff
  ];

  nativeBuildInputs = [ fixup_yarn_lock yarn nodejs ];

  yarnOfflineCache = fetchYarnDeps {
    yarnLock = src + "/yarn.lock";
    sha256 = "sha256-X6sWFShMjdHwv9dlqIEwTWbVorWi27bN+YSSdUEiGDU=";
  };

  configurePhase = ''
    runHook preConfigure
    export HOME=$PWD/tmp
    export NODE_OPTIONS=--openssl-legacy-provider
    mkdir -p $HOME
    yarn config --offline set yarn-offline-mirror ${yarnOfflineCache}
    fixup_yarn_lock yarn.lock
    yarn install --offline --frozen-lockfile --ignore-platform --ignore-scripts --no-progress --non-interactive
    patchShebangs node_modules/
    runHook postConfigure
  '';
  buildPhase = ''
    runHook preBuild
    export NODE_ENV=production
    yarn --offline build
    runHook postBuild
  '';
  installPhase = ''
    runHook preInstall
    mv dist $out
    runHook postInstall
  '';
}
