self: super:
{
  prometheus-bind-exporter = self.callPackage ./prometheus-bind-exporter { };
  prometheus-borg-exporter = self.callPackage ./prometheus-borg-exporter { };
  e1mo-ask = self.callPackage ./e1mo-ask { };
  opendatamap-net = self.callPackage ./opendatamap-net { };
  pressux = self.callPackage ./pressux { };
  sengi = self.callPackage ./sengi { };
  vikunja-api = self.callPackage ./vikunja/api.nix { };
  vikunja-frontend = self.callPackage ./vikunja/frontend.nix { };
  widevine-cdm = self.callPackage ./widevine { };
  setuptools-scm = self.callPackage ./setuptools-scm { };
}

