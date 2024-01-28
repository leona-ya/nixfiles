{ pkgs, lib, ... }: {
  boot.supportedFilesystems = lib.mkForce [ "bcachefs" "cifs" "vfat" "xfs" ];
  boot.kernelPackages = lib.mkForce pkgs.linuxPackages_6_7;
  boot.initrd.systemd.enable = true;
  services.fstrim.enable = false;
}
