{ self, lib, ... }: rec {

  flake.overlays.default = final: prev:
    let
      pseudoPkgs = (perSystem { pkgs = { }; }).packages;
    in
    builtins.mapAttrs (name: _: self.packages.${final.system}.${name}) pseudoPkgs;

  perSystem = { pkgs, ... }: {
    packages = {
      lldb = pkgs.lldb.overrideAttrs(oldAttrs: {
        dontCheckForBrokenSymlinks = true;
      });
      opendatamap-net = pkgs.callPackage ./opendatamap-net { };
      pressux = pkgs.callPackage ./pressux { };
      sengi = pkgs.callPackage ./sengi { };
      legitima = pkgs.callPackage ./legitima { };
      ical-merger = pkgs.callPackage ./ical-merger { };
      nomsable = pkgs.callPackage ./nomsable { };
      cups-brother-ptouch = pkgs.callPackage ./cups-brother-ptouch { };
      questrial-regular = pkgs.callPackage ./questrial { };
      #jetbrains-jdk-21 = pkgs.callPackage ./jetbrains-jdk-21;
      #gimp = pkgs.callPackage ./gimp {};
      annieuseyourtelescope = pkgs.callPackage ./annieuseyourtelescope { };
      fc-telegraf-collect-psi = pkgs.callPackage ./fc/telegraf-collect-psi { };
      wezterm = pkgs.wezterm.overrideAttrs({
        patches = [
          (pkgs.fetchpatch {
            url = "https://github.com/wez/wezterm/pull/6508.patch";
            hash = "sha256-eMpg206tUw8m0Sz+3Ox7HQnejPsWp0VHVw169/Rt4do=";
          })
        ];
      });
    };
  };
}
