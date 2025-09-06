{ lib, ... }:
{
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = "/dev/disk/by-id/nvme-CT500P310SSD8_25094E6EC357";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              size = "512M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
              };
            };
            luks = {
              size = "100%";
              content = {
                type = "luks";
                name = "cryptroot";
                extraOpenArgs = [ ];
                settings.allowDiscards = true;
                content = {
                  type = "lvm_pv";
                  vg = "main";
                };
              };
            };
          };
        };
      };
    };

    lvm_vg = {
      main = {
        type = "lvm_vg";
        lvs = {
          root = {
            size = "50G";
            content = {
              type = "filesystem";
              format = "xfs";
              mountpoint = "/";
            };
          };
          nix = {
            size = "50G";
            content = {
              type = "filesystem";
              format = "xfs";
              mountpoint = "/nix";
            };
          };
          home = {
            size = "20G";
            content = {
              type = "filesystem";
              format = "xfs";
              mountpoint = "/home";
            };
          };
        };
      };
    };
  };
}
