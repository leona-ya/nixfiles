{ lib, fetchFromGitea, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "prometheus-borg-exporter";
  version = "unstable-2021-08-28";

  src = fetchFromGitea {
    domain = "git.em0lar.dev";
    owner = "em0lar";
    repo = "prometheus-borg-exporter";
    rev = "d84fb8632951e7bf8a5b35037b9269b37501b1a1";
    sha256 = "sha256-uMRWDtisqXDiEB351y6v1XGr2RLk54yrVQ1k/4m9Q/k=";
  };

  cargoHash = "sha256-1v48mvhAqGDX2KX0yvmIf3YXLVQjj+Q9XQuudBP+YRU=";

  meta = with lib; {
    description = "Prometheus exporter for BorgBackup";
    homepage = "https://git.em0lar.dev/prometheus-borg-exporter";
    license = licenses.gpl3Plus;
  };
}
