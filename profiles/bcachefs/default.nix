{ pkgs, lib, ... }: {
  boot.supportedFilesystems = lib.mkForce [ "bcachefs" "cifs" "vfat" "xfs" ];
  boot.kernelPackages = lib.mkForce (pkgs.linuxPackagesFor (pkgs.linux_testing.override {
    argsOverride = rec {
      src = pkgs.fetchurl {
        url = "https://git.kernel.org/torvalds/t/linux-6.7-rc7.tar.gz";
        sha256 = "sha256-0MkigNsD1vd21vZ/rwNeupBLxfKgSoB9+rd9HrzjmwI=";
      };
      version = "6.7-rc7";
      modDirVersion = "6.7.0-rc7";
    };
  }));

  boot.initrd.systemd.enable = true;
  services.fstrim.enable = false;
}
