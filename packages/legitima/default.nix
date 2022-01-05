{ lib, fetchFromGitea, rustPlatform, makeWrapper, pkg-config, openssl }:

rustPlatform.buildRustPackage rec {
  pname = "legitima";
  version = "unstable-2021-01-02";

  src = fetchFromGitea {
    domain = "git.em0lar.dev";
    owner = "em0lar";
    repo = "legitima";
    rev = "42eb80a7c7c2286ef10d42b59d77fa76db6ff8e2";
    sha256 = "sha256-qPTTJKk1C2a7J8ema5oWfEPu7AcB5+GrtaQ0W+TXBjs=";
  };

  cargoSha256 = "sha256-LZDCJGePcX4yITMMBNVwrIz4Iz6w1+WYJCHTlHEuslI=";

  nativeBuildInputs = [ pkg-config makeWrapper ];
  buildInputs = [ openssl ];

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
    homepage = "https://git.em0lar.dev/em0lar/legitima";
    license = licenses.unlicense;
    maintainers = [ maintainers.em0lar ];
  };
}
