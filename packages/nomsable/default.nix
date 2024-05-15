{ poetry2nix
, fetchPypi
, fetchFromGitHub
, python3
, ...
}:
let
  python = python3.override {
    packageOverrides = self: super: {
      django = super.django_4;
      django-libsass =
        let
          py = python3.override {
            packageOverrides = self: super: { django = super.django_4; };
          };
        in
        python3.pkgs.buildPythonPackage rec {
          pname = "django-libsass";
          version = "0.9";
          format = "setuptools";

          src = fetchPypi {
            pname = "django-libsass";
            inherit version;
            hash = "sha256-v7u1WolQu0D6BN1BZgX5LaNK0fMDsQpBq8MjI4bsJ7U=";
          };

          propagatedBuildInputs = with py.pkgs; [
            django
            libsass
            django-compressor
          ];
        };
    };
  };
in
python.pkgs.buildPythonApplication {
  pname = "nomsable";
  version = "unstable-2022-01-31";
  format = "pyproject";

  src = /home/leona/dev/nomsable;

  nativeBuildInputs = with python.pkgs; [
    poetry-core
  ];

  propagatedBuildInputs = with python.pkgs; [
    django_4
    django-compressor
    django-libsass
    isodate
    requests
    pint
    beautifulsoup4
    setuptools
  ];

  installPhase = ''
    mkdir -p $out/lib/nomsable
    cp -r . $out/lib/nomsable
    chmod +x $out/lib/nomsable/manage.py
    makeWrapper $out/lib/nomsable/manage.py $out/bin/manage \
      --prefix PYTHONPATH : "$PYTHONPATH"
  '';

  passthru = {
    inherit python;
  };
}
