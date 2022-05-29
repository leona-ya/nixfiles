{ lib
, buildGoModule
, fetchFromGitHub
, sqliteSupport ? true
}:

buildGoModule rec {
  pname = "ory-hydra";
  version = "1.11.8";

  src = fetchFromGitHub {
    owner = "ory";
    repo = "hydra";
    rev = "v${version}";
    sha256 = "sha256-9V+nD7VfzXFijH/r7uP/FKyt/3UCWMJbMY6h8hW7Xm4=";
  };

  vendorSha256 = "sha256-AlTL4HJUogBhz/nTUH+3JKuq5I/nCv/erfoKSpwe/jE=";
  prePatch = ''
    rm -r internal/httpclient-next
  '';

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
