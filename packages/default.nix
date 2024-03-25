{ self, ... }: rec {

  flake.overlays.default = final: prev: let
    pseudoPkgs = (perSystem { pkgs = {}; }).packages;
  in builtins.mapAttrs (name: _: self.packages.${final.system}.${name}) pseudoPkgs;

  perSystem = { pkgs, ... }: {
    packages = {
      prometheus-bind-exporter = pkgs.callPackage ./prometheus-bind-exporter { };
      prometheus-borg-exporter = pkgs.callPackage ./prometheus-borg-exporter { };
      opendatamap-net = pkgs.callPackage ./opendatamap-net { };
      pressux = pkgs.callPackage ./pressux { };
      sengi = pkgs.callPackage ./sengi { };
      vikunja-api = pkgs.callPackage ./vikunja/api.nix { };
      vikunja-frontend = pkgs.callPackage ./vikunja/frontend.nix { };
      legitima = pkgs.callPackage ./legitima { };
      ory-hydra = pkgs.callPackage ./ory-hydra { };
      firefly-iii = pkgs.callPackage ./firefly-iii { };
      firefly-iii-data-importer = pkgs.callPackage ./firefly-iii-data-importer { };
      ical-merger = pkgs.callPackage ./ical-merger {};
      nomsable = pkgs.callPackage ./nomsable {};
      cups-brother-ptouch = pkgs.callPackage ./cups-brother-ptouch {};
      questrial-regular = pkgs.callPackage ./questrial {};
      #jetbrains-jdk-21 = pkgs.callPackage ./jetbrains-jdk-21;
      #gimp = pkgs.callPackage ./gimp {};
      annieuseyourtelescope = pkgs.callPackage ./annieuseyourtelescope {};
      power-profiles-daemon = pkgs.power-profiles-daemon.overrideAttrs (old: {
        version = "unstable-2024-01-16";
        src = pkgs.fetchFromGitLab {
          domain = "gitlab.freedesktop.org";
          owner = "hadess";
          repo = "power-profiles-daemon";
          rev = "53fb59a2b90f837375bec633ee59c00140f4d18d";
          sha256 = "sha256-Kjljrf/xhwbLtNkKDQWKMVlflQDurk7727ZwgU2p/Vc=";
        };
      });
      fc-telegraf-collect-psi = pkgs.callPackage ./fc/telegraf-collect-psi {};
      fprintd = pkgs.fprintd.overrideAttrs (_: { 
        mesonCheckFlags = [ 
          "--no-suite" "fprintd:TestPamFprintd"
        ]; 
      });
    };
  };
}
