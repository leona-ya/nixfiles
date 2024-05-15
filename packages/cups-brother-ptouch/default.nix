{ lib
, stdenv
, fetchgit
, autoreconfHook
, cups
, libpng
, perl
, perlPackages
, foomatic-db-engine
, patchPpdFilesHook
}:

stdenv.mkDerivation rec {
  pname = "cups-brother-ptouch";
  version = "unstable-2023-02-10";

  src = fetchgit {
    url = "https://github.com/leona-ya/printer-driver-ptouch.git";
    rev = "b6a86466b71b393c790801649ba6a2a412ab4db6";
    hash = "sha256-SvfZcbDI9I8RAG7xOwZgQw+ewSBgFWLe4JT53ssBdu0=";
  };

  nativeBuildInputs = [
    autoreconfHook
    perlPackages.XMLLibXML
    foomatic-db-engine
    patchPpdFilesHook
  ];

  buildInputs = [
    cups
    libpng
    perl
  ];

  postPatch = ''
    patchShebangs foomaticalize
  '';

  postInstall = ''
    export FOOMATICDB="$out/share/foomatic"
    mkdir -p "$out/share/cups/model/brother-ptouch"
    foomatic-compiledb -j "$NIX_BUILD_CORES" -d "$out/share/cups/model/brother-ptouch" -f
  '';

  ppdFileCommands = [ "rastertoptch" ];

  meta = with lib; {
    description = "Command line tool to print labels on Brother P-Touch printers on Linux";
    license = licenses.gpl3Plus;
    homepage = "https://mockmoon-cybernetics.ch/computer/p-touch2430pc/";
    maintainers = with maintainers; [ shamilton ];
    platforms = platforms.linux;
  };
}
