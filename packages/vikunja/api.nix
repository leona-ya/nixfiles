{ lib, buildGoModule, fetchgit }:

buildGoModule rec {
  pname = "vikunja-api";
  version = "0.17.0";

  src = fetchgit {
    url = "https://kolaente.dev/vikunja/api.git";
    rev = "v${version}";
    sha256 = "sha256-A9ZrJlGT2QZ9qPz/9XPgsBJqv1PA9Kb5scnXWzZnosc=";
  };

  vendorSha256 = "sha256-/vXyZznGxj5hxwqi4sttBBkEoS25DJqwoBtADCRO9Qc=";

  # checks need to be disabled because of needed internet for some checks
  doCheck = false;
}
