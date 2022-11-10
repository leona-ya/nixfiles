{ lib, fetchFromGitHub, rustPlatform, openssl, pkg-config, perl }:

rustPlatform.buildRustPackage rec {
  pname = "ical-merger";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "elikoga";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-1Lj4UGnb/ZjNn+2rq3VWRrY4ES5bONbdKYCudg5UIYQ=";
  };

  cargoSha256 = "sha256-jBhjF/Hu6hgede2Ou2OC1yFy3YOXRFNKdKA7N3JbEbs=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ];
  OPENSSL_NO_VENDOR = 1;

  outputs = [ "out" ];

  meta = with lib; {
    description = "";
    homepage = "https://github.com/elikoga/ical-merger";
    license = licenses.mit;
    maintainers = [ maintainers.leona ];
  };
}
