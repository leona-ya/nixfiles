# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/profiles/qemu-guest.nix")
    ];

  boot.initrd.availableKernelModules = [ "ahci" "xhci_pci" "virtio_pci" "sr_mod" "virtio_blk" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/af4f509d-7995-4078-8e38-e52243b5f4d5";
      fsType = "xfs";
    };

  boot.initrd.luks.devices."cryptroot".device = "/dev/disk/by-uuid/42bd4cfd-3824-422d-8098-2e972e0384ca";

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/8EB4-68C6";
      fsType = "vfat";
    };

  swapDevices = [ ];

  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
