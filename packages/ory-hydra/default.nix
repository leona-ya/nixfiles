{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "ory-hydra";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "ory";
    repo = "hydra";
    rev = "v${version}";
    sha256 = "sha256-m1iTPOXWCJ4X/KRDgtF61EeDX6SpFUunVJCEZSA90hw=";
  };

  vendorSha256 = "sha256-+g5X41a/5PyXiSL1SWTGavvmYcUBbDs+9a3divV/Cjk=";
  prePatch = ''
    rm -r internal/httpclient
  '';

  preBuild =
    ''
      export buildFlagsArray=(
        -tags="sqlite,json1"
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
