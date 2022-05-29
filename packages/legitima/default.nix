{ lib, fetchgit, rustPlatform, makeWrapper, pkg-config, openssl, postgresql }:

rustPlatform.buildRustPackage rec {
  pname = "legitima";
  version = "unstable-2021-05-29";

  src = fetchgit {
    url = "https://cyberchaos.dev/leona/legitima.git";
    rev = "abd4a31b3c85dba2f3568b44d39d1c49f5fd2fd4";
    sha256 = "sha256-3+rDAmGHXI5OEuBfbwcb2Ko3/UDDxPRL77+IdjMWbi8=";
  };

  cargoSha256 = "sha256-cMlgdFKVxi5r+SanXbT7HkMOHuLJ16uOEp3ObLn7RR0=";

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
