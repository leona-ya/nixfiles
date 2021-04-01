{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/profiles/qemu-guest.nix")
    ];

  boot.initrd.availableKernelModules = [ "ata_piix" "virtio_pci" "xhci_pci" "sd_mod" "sr_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/303b625b-05d7-4368-97fe-0711bb99b826";
      fsType = "ext4";
    };

  boot.initrd.luks.devices."cryptroot".device = "/dev/disk/by-uuid/5b0aa515-d260-42fc-b2b7-8f178359b51b";

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/B965-A55E";
      fsType = "vfat";
    };

  swapDevices = [ ];

}
