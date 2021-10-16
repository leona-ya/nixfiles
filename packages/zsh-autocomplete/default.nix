{ lib, stdenv, fetchFromGitHub, zsh }:

# To make use of this derivation, use the `programs.zsh.autosuggestions.enable` option

stdenv.mkDerivation rec {
  pname = "zsh-autocomplete";
  version = "21.09.22";

  src = fetchFromGitHub {
    owner = "marlonrichert";
    repo = "zsh-autocomplete";
    rev = "${version}";
    sha256 = "sha256-c4+5ta0ATuy9hIygSnqaquHf+YIStvHMaABwq3qyru8=";
  };

  buildInputs = [ zsh ];

  installPhase = ''
    install -D zsh-autocomplete.plugin.zsh $out/share/zsh-autocomplete/zsh-autocomplete.plugin.zsh
    cp -R scripts $out/share/zsh-autocomplete/scripts
    cp -R functions $out/share/zsh-autocomplete/functions
  '';

  meta = with lib; {
    description = "Real-time type-ahead completion for Zsh. Asynchronous find-as-you-type autocompletion.";
    homepage = "https://github.com/zsh-users/zsh-autosuggestions";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = [ maintainers.em0lar ];
  };
}
