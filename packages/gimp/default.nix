{
  stdenv,
  lib,
  aalib,
  alsa-lib,
  appstream,
  appstream-glib,
  babl,
  bashInteractive,
  cairo,
  desktop-file-utils,
  fetchurl,
  findutils,
  gdk-pixbuf,
  gegl,
  gexiv2,
  ghostscript,
  gi-docgen,
  gjs,
  glib,
  glib-networking,
  gobject-introspection,
  gtk3,
  isocodes,
  lcms,
  libarchive,
  libgudev,
  libheif,
  libjxl,
  libmng,
  libmypaint,
  librsvg,
  libwebp,
  libwmf,
  libxslt,
  lua,
  luajit,
  meson,
  mypaint-brushes1,
  ninja,
  openexr,
  perl538,
  pkg-config,
  poppler,
  poppler_data,
  python,
  python3,
  shared-mime-info,
  vala,
  wrapGAppsHook,
  xorg,
  xvfb-run,
}:

let
  python = python3.withPackages (pp: [ pp.pygobject3 ]);
  lua = luajit.withPackages (ps: [ ps.lgi ]);
in
stdenv.mkDerivation (finalAttrs: {
  pname = "gimp";
  version = "2.99.16";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchurl {
    url = "http://download.gimp.org/pub/gimp/v${lib.versions.majorMinor finalAttrs.version}/gimp-${finalAttrs.version}.tar.xz";
    sha256 = "sha256-a0SW7e5Eczn5IydnVSR+rbZOxA2K7CQdBrYtGm62UI0=";
  };

  patches = [
    ./meson-gtls.patch
    ./hardcore-plugin-interpreters.patch
  ];

  nativeBuildInputs = [
    pkg-config
    libxslt
    ghostscript
    libarchive
    bashInteractive
    libheif
    libwebp
    libmng
    aalib
    libjxl
    isocodes
    perl538
    appstream
    meson
    xvfb-run
    gi-docgen
    findutils
    vala
    alsa-lib
    ninja
    wrapGAppsHook
  ];

  buildInputs = [
    gjs
    lua
    babl
    appstream-glib
    gegl
    gtk3
    glib
    gdk-pixbuf
    cairo
    gexiv2
    lcms
    libjxl
    poppler
    poppler_data
    openexr
    libmng
    librsvg
    desktop-file-utils
    libwmf
    ghostscript
    aalib
    shared-mime-info
    libwebp
    libheif
    xorg.libXpm
    xorg.libXmu
    glib-networking
    libmypaint
    mypaint-brushes1
    gobject-introspection
    python
    libgudev
  ];

  preConfigure = "patchShebangs tools/gimp-mkenums app/tests/create_test_env.sh plug-ins/script-fu/scripts/ts-helloworld.scm";

  enableParallelBuilding = true;

  doCheck = false;

  meta = with lib; {
    description = "The GNU Image Manipulation Program";
    homepage = "https://www.gimp.org/";
    maintainers = with maintainers; [ jtojnar ];
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    mainProgram = "gimp";
  };
})
