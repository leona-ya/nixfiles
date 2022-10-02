{ lib, fetchgit, rustPlatform, makeWrapper, pkg-config, openssl, postgresql }:

rustPlatform.buildRustPackage rec {
  pname = "legitima";
  version = "unstable-2022-10-02";

  src = fetchgit {
    url = "https://cyberchaos.dev/leona/legitima.git";
    rev = "ed8c02d27a8f31185cbb03225ba4b80ba8742e01";
    sha256 = "sha256-dE6+NHqMgngredkIxhhlnKpkb5iKe7G2GyoE46iWt9o=";
  };

  cargoSha256 = "sha256-cv9aR+KR4q6spCi9u/ZRXgKSoL+nPJDqF3EtfPAq4Y4=";

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
