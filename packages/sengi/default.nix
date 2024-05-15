{ lib, fetchurl, appimageTools }:

let
  pname = "sengi";
  version = "1.1.4";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "https://github.com/NicolasConstant/sengi/releases/download/${version}/Sengi-${version}-linux.AppImage";
    sha256 = "sha256-Wd6gMu1Nt+/jRq1qsEFjEaXXgc5JEbdU47+gbS9YtbM=";
    name = "${name}.AppImage";
  };

  appimageContents = appimageTools.extractType2 {
    inherit name src;
  };

in
appimageTools.wrapType2 {
  inherit name src;

  extraInstallCommands = ''
    mv $out/bin/${name} $out/bin/${pname}
    install -m 444 -D ${appimageContents}/sengi.desktop $out/share/applications/sengi.desktop
    install -m 444 -D ${appimageContents}/usr/share/icons/hicolor/512x512/apps/sengi.png \
      $out/share/icons/hicolor/512x512/apps/sengi.png
    substituteInPlace $out/share/applications/sengi.desktop \
      --replace 'Exec=AppRun' 'Exec=${pname}'
  '';

  meta = with lib; {
    description = "Mastodon & Pleroma Multi-account Desktop Client";
    homepage = "https://nicolasconstant.github.io/sengi/";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ leona ];
    platforms = [ "x86_64-linux" ];
  };
}
