{ lib, rustPlatform, fetchFromGitea, pkg-config, openssl }:

rustPlatform.buildRustPackage rec {
  pname = "pressux";
  version = "unstable-2021-09-11";


  src = fetchFromGitea {
    domain = "git.em0lar.dev";
    owner = "em0lar";
    repo = "pressux";
    rev = "03ce95030ac34f92e5a139b05177b5be38119e0d";
    sha256 = "sha256-szpbvfa6E4iZ8HpJNlfT0oT3Gj37TZJ+4KKRl9vPc/8=";
  };

  cargoSha256 = "sha256-nnd4LiH2Fq21hMlRybX21WH1nJkS5Qs4n69awgNBSKs=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ];

  meta = with lib; {
    description = "A helper for printing and scanning";
    homepage = "https://git.em0lar.dev/em0lar/pressux";
    license = licenses.unlicense;
    maintainers = [ maintainers.em0lar ];
  };
}
