{ lib, fetchgit, rustPlatform, makeWrapper, pkg-config, openssl, postgresql }:

rustPlatform.buildRustPackage rec {
  pname = "legitima";
  version = "unstable-2022-10-11";

  src = fetchgit {
    url = "https://cyberchaos.dev/leona/legitima.git";
    rev = "4539a6dbaf310f13e78c62b380ef1d478591c412";
    sha256 = "sha256-POT30grcSEkGXKq2qnVQvdE4LMTncmRxkalvWme8blY=";
  };

  cargoSha256 = "sha256-SDuLcCTliuwT0qBEsuTHwaczDb796dFeVhbWCnxqryA=";

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
