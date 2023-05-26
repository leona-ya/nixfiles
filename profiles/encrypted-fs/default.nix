{ config, ... }: {
  boot.initrd.availableKernelModules = [ "virtio_pci" ];
  boot.initrd.network = {
    enable = true;
    ssh = {
      enable = true;
      port = 222;
      authorizedKeys = config.users.users.leona.openssh.authorizedKeys.keys;
      hostKeys = [ "/boot/ssh_host_ed25519" ];
    };
  };
  networking.interfaces."eth0".useDHCP = true;
}