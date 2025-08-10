{ config, pkgs, lib, ... }: {
  boot = {
    initrd = {
      availableKernelModules = [ "r8169" "virtio_pci" ];
      network = {
        enable = true;
        ssh = {
          enable = true;
          port = 222;
          authorizedKeys = config.users.users.leona.openssh.authorizedKeys.keys;
          hostKeys = [
            "/boot/ssh_initrd_ed25519"
          ];
        };
      };
      systemd = {
        enable = true;
        network = {
          enable = true;
          networks."10-dhcp" = {
            matchConfig.Name = "eth0";
            DHCP = "yes";
          };
        };
        targets.initrd.wants = [
          "systemd-networkd-wait-online@eth0.service"
        ];
        users.root.shell = "/bin/systemd-tty-ask-password-agent";
      };
    };
  };
}
