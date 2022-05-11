self: super:
rec {
  prometheus-bind-exporter = self.callPackage ./prometheus-bind-exporter { };
  prometheus-borg-exporter = self.callPackage ./prometheus-borg-exporter { };
  e1mo-ask = self.callPackage ./e1mo-ask { };
  opendatamap-net = self.callPackage ./opendatamap-net { };
  pressux = self.callPackage ./pressux { };
  sengi = self.callPackage ./sengi { };
  vikunja-api = self.callPackage ./vikunja/api.nix { };
  vikunja-frontend = self.callPackage ./vikunja/frontend.nix { };
  legitima = self.callPackage ./legitima { };
  ory-hydra = self.callPackage ./ory-hydra { };
  firefly-iii = self.callPackage ./firefly-iii { };
  firefly-iii-data-importer = self.callPackage ./firefly-iii-data-importer { };
#  jetbrains = (self.recurseIntoAttrs (self.callPackages ./jetbrains {
#    vmopts = null;
#    jdk = jetbrains.jdk;
#  }) // {
#    jdk = super.jetbrains.jdk;
#  });
  swaylock-effects = super.swaylock-effects.overrideAttrs ( old: rec {
    name = "swaylock-effects-${version}";
    version = "unstable-2021-10-10";
    src = super.fetchFromGitHub {
      owner = "mortie";
      repo = "swaylock-effects";
      rev = "a8fc557b86e70f2f7a30ca9ff9b3124f89e7f204";
      sha256 = "sha256-GN+cxzC11Dk1nN9wVWIyv+rCrg4yaHnCePRYS1c4JTk=";
    };
    patches = [];
  });
}
