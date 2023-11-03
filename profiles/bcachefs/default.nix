{ pkgs, lib, ... }: {
  boot.supportedFilesystems = lib.mkForce [ "bcachefs" "cifs" "vfat" "xfs" ];
# working:
#  boot.kernelPackages = lib.mkForce (pkgs.linuxPackagesFor (pkgs.linux_6_6.override {
#    argsOverride = rec {
#      src = pkgs.fetchurl {
#        url = "https://thia.net.leona.is/public/bcachefs-b9bd69421f7364ca4ff11c827fd0e171a8b826ea.tar";
#        hash = "sha256-wVC3ZOVsLHI/E96CRpcUI6vU/xdA4WcLUnOPjJY0LSo=";
#        nativeBuildInputs = [ pkgs.zstd ];
#      };
#      version = "6.6.0";
#      modDirVersion = "6.6.0";
#    };
#  }));
  boot.kernelPackages = lib.mkForce pkgs.linuxKernel.packages.linux_6_6;
  boot.kernelPatches = let
    #currentCommit = "f08edfa688ab57800822f9176e1cd08042543c94";
    currentCommit = "b9bd69421f7364ca4ff11c827fd0e171a8b826ea";
  in [{
    name = "bcachefs-${currentCommit}";
    patch = pkgs.fetchpatch {
      name = "bcachefs-${currentCommit}.diff";
      url = "https://evilpiepirate.org/git/bcachefs.git/rawdiff/?id=${currentCommit}&id2=v6.6";
      sha256 = "sha256-+Gp/1kTBgRx5a01l9xtaDbiLuOP58uZ7rx27WyYcMT4=";
    };
    # extra config is inherited through boot.supportedFilesystems
  }];
}
