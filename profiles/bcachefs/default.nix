{ pkgs, lib, ... }: {
  boot.supportedFilesystems = lib.mkForce [ "bcachefs" "cifs" "vfat" "xfs" ];
  boot.kernelPackages = lib.mkForce pkgs.linuxKernel.packages.linux_6_6;
  boot.kernelPatches = let
    currentCommit = "b9bd69421f7364ca4ff11c827fd0e171a8b826ea";
  in [{
    name = "bcachefs-${currentCommit}";
    patch = pkgs.fetchpatch {
      name = "bcachefs-${currentCommit}.diff";
      url = "https://evilpiepirate.org/git/bcachefs.git/rawdiff/?id=${currentCommit}&id2=v6.6";
      sha256 = "sha256-+Gp/1kTBgRx5a01l9xtaDbiLuOP58uZ7rx27WyYcMT4=";
    };
    extraStructuredConfig = with lib.kernel; {
      BCACHEFS_FS = module;
      BCACHEFS_QUOTA = option yes;
      BCACHEFS_POSIX_ACL = option yes;
      BCACHEFS_LOCK_TIME_STATS = option yes;
    };
  }];

  services.fstrim.enable = false;
}
