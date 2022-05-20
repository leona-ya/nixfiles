{ lib, fetchgit, rustPlatform, makeWrapper, pkg-config, openssl, postgresql }:

rustPlatform.buildRustPackage rec {
  pname = "legitima";
  version = "unstable-2021-05-20";

  src = fetchgit {
    url = "https://cyberchaos.dev/leona/legitima.git";
    rev = "1b9212612ac6431b04b5d569324c33083afcb5b2";
    sha256 = "sha256-I35Auk8lX+KlSima3aaJ2wEMDQnTD2MTYdlVBWt2Jxg=";
  };

  cargoSha256 = "sha256-9uPXH6/4s6DHvOVOvXd6pRnZMUqm+it3fdoRzGExvHY=";

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
