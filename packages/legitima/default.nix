{ lib, fetchgit, rustPlatform, makeWrapper, pkg-config, openssl }:

rustPlatform.buildRustPackage rec {
  pname = "legitima";
  version = "unstable-2021-01-30";

  src = fetchgit {
    url = "https://cyberchaos.dev/em0lar/legitima.git";
    rev = "9ab8fc28f10b88eb3edfa83fbfdfb3987ab3ccb8";
    sha256 = "sha256-T2koCkjg8XQIZHbQvU+wNlH90IRmhzTTPLx6iCX5lnk=";
  };

  cargoSha256 = "sha256-U3dI08NDi/OruTO5NIJx6y/cBQM0hs5+EU21u9kloWg=";

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
    homepage = "https://cyberchaos.dev/em0lar/legitima";
    license = licenses.unlicense;
    maintainers = [ maintainers.em0lar ];
  };
}
