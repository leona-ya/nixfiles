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
  zsh-autocomplete = self.callPackage ./zsh-autocomplete { };
  legitima = self.callPackage ./legitima { };
  ory-hydra = self.callPackage ./ory-hydra { };
  #mesa = super.mesa.overrideAttrs (old: rec {
  #  version = "21.2.6";
  #  src = self.fetchurl {
  #    urls = [
  #      "https://mesa.freedesktop.org/archive/mesa-${version}.tar.xz"
  #      "ftp://ftp.freedesktop.org/pub/mesa/mesa-${version}.tar.xz"
  #      "ftp://ftp.freedesktop.org/pub/mesa/${version}/mesa-${version}.tar.xz"
  #      "ftp://ftp.freedesktop.org/pub/mesa/older-versions/21.x/${version}/mesa-${version}.tar.xz"
  #    ];
  #    sha256 = "0m69h3f9fr66h6xjxfc485zfdci6kl8j24ab0kx5k23f7kcj4zhy";
  #  };
  #});
  jetbrains = (self.recurseIntoAttrs (self.callPackages ./jetbrains {
    vmopts = null;
    jdk = jetbrains.jdk;
  }) // {
    jdk = super.jetbrains.jdk;
  });
}
