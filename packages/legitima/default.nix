{ lib, fetchgit, rustPlatform, makeWrapper, pkg-config, openssl, postgresql }:

rustPlatform.buildRustPackage rec {
  pname = "legitima";
  version = "unstable-2021-04-17";

  src = fetchgit {
    url = "https://cyberchaos.dev/leona/legitima.git";
    rev = "fef51477d5f3193873cb97cf1273073c428452ff";
    sha256 = "sha256-S/Cm40X+MX8vWJxFUbtzms3SXl0vsE5LM2jrwSEfyu0=";
  };

  cargoSha256 = "sha256-dufG0KtzL9vhi42WCqiVbnm/oj4XA//VQfjjKQ3skfs=";

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
