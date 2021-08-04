{ lib, fetchFromGitea, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "prometheus-borg-exporter";
  version = "unstable-2021-08-04";

  src = fetchFromGitea {
    domain = "git.em0lar.dev";
    owner = "em0lar";
    repo = "prometheus-borg-exporter";
    rev = "b4acd197378a590c9d805310fd5ee105bb36865d";
    sha256 = "sha256-rghIVHs6bJsgtSj1hDXIhlpgZu7ieXUue1HDfVkXP9Y=";
  };

  cargoHash = "sha256-AI21pKsoHHrQJl/YzwksK1o2bt2QQcQFkn55H9bliKk=";

  meta = with lib; {
    description = "Prometheus exporter for BorgBackup";
    homepage = "https://git.em0lar.dev/prometheus-borg-exporter";
    license = licenses.gpl3Plus;
  };
}
