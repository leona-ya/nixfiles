{ lib, fetchgit, rustPlatform, makeWrapper, pkg-config, openssl, postgresql }:

rustPlatform.buildRustPackage rec {
  pname = "legitima";
  version = "unstable-2022-11-26";

  src = fetchgit {
    url = "https://cyberchaos.dev/leona/legitima.git";
    rev = "935f0fad8377f041e1dd3a740eccce0778a3edca";
    sha256 = "sha256-Oz7V/EQ0jwv3u5b50JiqnLaG3lO2vtlDtq5RKIAodZs=";
  };

  cargoLock.lockFile = ./Cargo.lock;

  cargoLock.outputHashes = {
    "ory-hydra-client-2.0.1" = "sha256-MzZf9S6VOynQnmfw9jGg9yVZz9Kyxt9tyFpPA6LN2Oo=";
    "rocket_db_pools-0.1.0-rc.2" = "sha256-899Nd/OQYGYPBzXIr0LnZOysjVmKxOxrG1g7xV59q38=";
    "rocket_sync_db_pools-0.1.0-rc.1" = "sha256-p+Lm2hF8JTdt5BaNECestNjfMV0GpizFvqxRuvl/M4k=";
  };


  nativeBuildInputs = [ pkg-config makeWrapper ];
  buildInputs = [ openssl postgresql.lib ];

  preBuild = ''
    export LEGITIMA_STATIC_ROOT_PATH=$data
  '';

  postInstall = ''
    mkdir $data
    cp -R $src/{static,templates} $data
    wrapProgram $out/bin/legitima \
      --set-default ROCKET_TEMPLATE_DIR "$data/templates"
  '';

  outputs = [ "out" "data" ];


  meta = with lib; {
    description = "";
    homepage = "https://cyberchaos.dev/leona/legitima";
    license = licenses.unlicense;
    maintainers = [ maintainers.leona ];
  };
}
