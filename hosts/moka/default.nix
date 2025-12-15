{ config, pkgs, lib, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../users/transcaffeine
    ./dns.nix
    ./network.nix
    ./libvirt.nix
  ];

  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = lib.mkForce pkgs.linuxPackages;
  boot.kernelParams = [
    "zfs.zfs_arc_max=3221225472"
    "zfs.zfs_arc_min=1073741824"
  ];
  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    mirroredBoots = lib.map (id: {
      devices = [ "nodev" ];
      path = "/boot/disk${id}";
      efiSysMountPoint = "/boot/disk${id}";
    }) [ "0" "1" "2" ];
  };
  l.remote-unlock = {
    enable = true;
    hostKeyPath = "/boot/disk0/ssh_initrd_ed25519";
  };

  l.sops.secrets."all/users/root_pw".enable = false;
  l.sops.secrets."hosts/moka/user_root_pw".neededForUsers = true;
  users.users.root.hashedPasswordFile = config.sops.secrets."hosts/moka/user_root_pw".path;

  services.zfs.autoScrub.enable = true;

  networking.hostId = "0c0ffee0";
  system.stateVersion = "25.11";
}
