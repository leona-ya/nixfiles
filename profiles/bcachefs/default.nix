{ pkgs, lib, ... }: {
  boot.supportedFilesystems = lib.mkForce [ "bcachefs" "cifs" "vfat" "xfs" ];
  boot.kernelPackages = lib.mkForce (pkgs.linuxPackagesFor (pkgs.linux_testing.override {
    argsOverride = rec {
      src = pkgs.fetchurl {
        url = "https://git.kernel.org/torvalds/t/linux-6.7-rc5.tar.gz";
        sha256 = "sha256-8yrRuObgvY7tEdIj6EDRXaBGS/NBMUVHjaHxHgunYBE=";
      };
      version = "6.7-rc5";
      modDirVersion = "6.7.0-rc5";
    };
  }));

  boot.initrd.systemd.enable = true;
  services.fstrim.enable = false;
}
