{ lib, fetchgit, rustPlatform, makeWrapper, pkg-config, openssl, postgresql }:

rustPlatform.buildRustPackage rec {
  pname = "legitima";
  version = "unstable-2021-06-17";

  src = fetchgit {
    url = "https://cyberchaos.dev/leona/legitima.git";
    rev = "319077bcb65f302abc072389ff60ddbe9741f9fb";
    sha256 = "sha256-k0X8su3mQd0smj0WaxvpoG19BefFweEg9R2LvIT+Gco=";
  };

  cargoSha256 = "sha256-c/GSKkkX+v+ZOCltWM0BzoTa0uDjY4sM+ndCyv4okCM=";

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
