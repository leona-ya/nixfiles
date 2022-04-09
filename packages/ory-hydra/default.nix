{ lib
, buildGoModule
, fetchFromGitHub
, sqliteSupport ? true
}:

buildGoModule rec {
  pname = "ory-hydra";
  version = "1.10.7";

  src = fetchFromGitHub {
    owner = "ory";
    repo = "hydra";
    rev = "v${version}";
    sha256 = "sha256-/cuzMTOMtju24tRO8KtW8yzztYFj9dSZRnYOMyAVMsk=";
  };

  vendorSha256 = "sha256-H3lAjlDpEcdQlFc5mwHOHhPjTSltUEleKIyZwUcXmtI=";

  preBuild =
    let
      tags = lib.optional sqliteSupport "sqlite";
      tagsString = lib.concatStringsSep " " tags;
    in
    ''
      export buildFlagsArray=(
        -tags="${tagsString}"
      )
    '';

  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/vouch/vouch-proxy";
    description = "An SSO and OAuth / OIDC login solution for NGINX using the auth_request module";
    license = licenses.mit;
    maintainers = with maintainers; [ leona ];
  };
}
