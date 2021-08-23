{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "vouch-proxy";
  version = "unstable-2021-08-22";

  src = fetchFromGitHub {
    owner = "vouch";
    repo = "vouch-proxy";
    rev = "ab754cdf520d2eaaf967675066169dc6014658ab";
    sha256 = "sha256-lx2lsTmKBHdJxOeBqaeinRc9MGXwmZA1BUG+jnRJVJ0=";
  };

  vendorSha256 = "sha256-ifH+420FIrib+zQtzzHtMMYd84BED+vgnRw4xToYIl4=";

  ldflags = [
    "-s" "-w"
    "-X main.version=${version}"
  ];

  preCheck = ''
    export VOUCH_ROOT=$PWD
  '';

  meta = with lib; {
    homepage = "https://github.com/vouch/vouch-proxy";
    description = "An SSO and OAuth / OIDC login solution for NGINX using the auth_request module";
    license = licenses.mit;
    maintainers = with maintainers; [ em0lar ];
  };
}
