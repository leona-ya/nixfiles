{
  fetchFromGitLab,
  fetchYarnDeps,
  stdenv,
  fixup_yarn_lock,
  yarn,
  nodejs,
  substituteAll,
}:

stdenv.mkDerivation rec {
  pname = "pleroma-fe";
  version = "2.7.1";

  src = fetchFromGitLab {
    domain = "git.pleroma.social";
    owner = "pleroma";
    repo = pname;
    rev = version;
    sha256 = "sha256-iozym/Mlm0AN/TrVqdZRhroj7FUOr3o6/zTR/AT+l54=";
  };

  patches = [
    ./allow-private-repeats.diff
  ];

  nativeBuildInputs = [
    fixup_yarn_lock
    yarn
    nodejs
  ];

  yarnOfflineCache = fetchYarnDeps {
    yarnLock = src + "/yarn.lock";
    sha256 = "sha256-nR3qxg74qg9ksOtH70ALuMhkI2VZPIIzXlECMwKhtak=";
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
