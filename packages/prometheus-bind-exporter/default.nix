{ lib, buildGoPackage, fetchFromGitHub, nixosTests }:

buildGoPackage rec {
  pname = "bind_exporter";
  version = "0.4.0";

  goPackagePath = "github.com/digitalocean/bind_exporter";

  src = fetchFromGitHub {
    owner = "digitalocean";
    repo = "bind_exporter";
    rev = "v0.4.0";
    sha256 = "1nd6pc1z627w4x55vd42zfhlqxxjmfsa9lyn0g6qq19k4l85v1qm";
  };

  passthru.tests = { inherit (nixosTests.prometheus-exporters) bind; };

  meta = with lib; {
    description = "Prometheus exporter for bind9 server";
    homepage = "https://github.com/digitalocean/bind_exporter";
    license = licenses.asl20;
    maintainers = with maintainers; [ rtreffer ];
    platforms = platforms.unix;
  };
}
