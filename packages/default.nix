prev: final:
rec {
  prometheus-bind-exporter = prev.callPackage ./prometheus-bind-exporter { };
  prometheus-borg-exporter = prev.callPackage ./prometheus-borg-exporter { };
  opendatamap-net = prev.callPackage ./opendatamap-net { };
  pressux = prev.callPackage ./pressux { };
  sengi = prev.callPackage ./sengi { };
  vikunja-api = prev.callPackage ./vikunja/api.nix { };
  vikunja-frontend = prev.callPackage ./vikunja/frontend.nix { };
  legitima = prev.callPackage ./legitima { };
  ory-hydra = prev.callPackage ./ory-hydra { };
  firefly-iii = prev.callPackage ./firefly-iii { };
  firefly-iii-data-importer = prev.callPackage ./firefly-iii-data-importer { };
  #jetbrains = (prev.recurseIntoAttrs (prev.callPackages ./jetbrains {
  #  vmopts = null;
  #  jdk = jetbrains.jdk;
  #}) // {
  #  jdk = final.jetbrains.jdk;
  #});
  swaylock-effects = final.swaylock-effects.overrideAttrs ( old: rec {
    name = "swaylock-effects-${version}";
    version = "unstable-2021-10-10";
    src = final.fetchFromGitHub {
      owner = "mortie";
      repo = "swaylock-effects";
      rev = "a8fc557b86e70f2f7a30ca9ff9b3124f89e7f204";
      sha256 = "sha256-GN+cxzC11Dk1nN9wVWIyv+rCrg4yaHnCePRYS1c4JTk=";
    };
    patches = [];
  });
  ical-merger = prev.callPackage ./ical-merger {};
  nomsable = prev.callPackage ./nomsable {};
  cups-brother-ptouch = prev.callPackage ./cups-brother-ptouch {};
  questrial-regular = prev.callPackage ./questrial {};
  iwd = final.iwd.overrideAttrs(old: rec {
    patches = [
      (prev.fetchpatch {
        name = "8d2e35b2d46fd9bfd23e7c3036d2bd116d2bb64a.patch";
        url = "https://git.kernel.org/pub/scm/network/wireless/iwd.git/patch/?id=8d2e35b2d46fd9bfd23e7c3036d2bd116d2bb64a";
        hash = "sha256-MqYkOKcK6xM+MnehPQUKbjRgqJUZznZtzmu2ChEINNk=";
      })
    ];
  });
  #jetbrains-jdk-21 = prev.callPackage ./jetbrains-jdk-21;
  gimp = prev.callPackage ./gimp {};
}
