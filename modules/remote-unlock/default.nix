{
  config,
  pkgs,
  lib,
  ...
}: let
cfg = config.l.remote-unlock;
in {
  options.l.remote-unlock = {
    enable = lib.mkEnableOption "remote unlock capabilites";
    kernelModules = lib.mkOption {
      type = with lib.types; listOf str;
      default = [ "r8169" "virtio_pci" ];
      description = "kernel modules required for remote unlock (mostly network)";
    };
    hostKeyPath = lib.mkOption {
      type = lib.types.str;
      default = "/boot/ssh_initrd_ed25519";
      description = "path to the ssh hostkey used by initrd";
    };
  };
  config = lib.mkIf cfg.enable {
    boot = {
      initrd = {
        availableKernelModules = cfg.kernelModules;
        network = {
          enable = true;
          ssh = {
            enable = true;
            port = 222;
            authorizedKeys = config.users.users.leona.openssh.authorizedKeys.keys;
            hostKeys = [
              cfg.hostKeyPath
            ];
          };
        };
        systemd = {
          enable = true;
          network = {
            enable = true;
            links = {
              inherit (config.systemd.network.links) "10-eth0";
            };
            networks = {
              inherit (config.systemd.network.networks) "10-eth0";
            };
          };
          targets.initrd.wants = [
            "systemd-networkd-wait-online@eth0.service"
          ];
          users.root.shell = "/bin/systemd-tty-ask-password-agent";
        };
      };
    };
  };
}
