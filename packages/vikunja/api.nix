{ lib, buildGoModule, fetchgit }:

buildGoModule rec {
  pname = "vikunja-api";
  version = "88c3bd43a494171c32a07caf4f06a5c9419f01be";

  src = fetchgit {
    url = "https://kolaente.dev/vikunja/api.git";
    rev = "${version}";
    sha256 = "sha256-zDKmWMCj7ms3pE/0yVsR0666TqBAll0QeyNzYAAkDNU=";
  };

  vendorSha256 = "sha256-COdU/0mNpYhHieJLUSRtH6dhkTw6YhBnGJ8xc10J5jU=";

  # checks need to be disabled because of needed internet for some checks
  doCheck = false;
}
