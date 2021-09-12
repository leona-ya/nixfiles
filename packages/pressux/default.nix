{ lib, rustPlatform, fetchFromGitea, pkg-config, openssl, cups }:

rustPlatform.buildRustPackage rec {
  pname = "pressux";
  version = "unstable-2021-09-11";


  src = fetchFromGitea {
    domain = "git.em0lar.dev";
    owner = "em0lar";
    repo = "pressux";
    rev = "ab34b4a9c049ef6cfd55d5357ea051b7e2b22e25";
    sha256 = "sha256-MRIRxRZkH9c86vcRg++svAKV4OHVEoyh1raTXjEy3p0=";
  };

  cargoSha256 = "sha256-nnd4LiH2Fq21hMlRybX21WH1nJkS5Qs4n69awgNBSKs=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl cups ];

  meta = with lib; {
    description = "A helper for printing and scanning";
    homepage = "https://git.em0lar.dev/em0lar/pressux";
    license = licenses.unlicense;
    maintainers = [ maintainers.em0lar ];
  };
}
