self: super:
{
  bind = self.callPackage ./bind { };
  prometheus-bind-exporter = self.callPackage ./prometheus-bind-exporter { };
  prometheus-borg-exporter = self.callPackage ./prometheus-borg-exporter { };
  e1mo-ask = self.callPackage ./e1mo-ask { };
  opendatamap-net = self.callPackage ./opendatamap-net { };
  sengi = self.callPackage ./sengi { };
  widevine-cdm = self.callPackage ./widevine { };
}

