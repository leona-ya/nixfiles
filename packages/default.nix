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
  widevine-cdm = self.callPackage ./widevine { };
  python = super.python3.override {
    packageOverrides = self: super: {
      ocrmypdf = self.callPackage ./ocrmypdf { };
    };
  };
  zsh-autocomplete = self.callPackage ./zsh-autocomplete { };
  jetbrains = (self.recurseIntoAttrs (self.callPackages ./jetbrains {
    vmopts = null;
    jdk = jetbrains.jdk;
  }) // {
    jdk = super.jetbrains.jdk;
  });
}

