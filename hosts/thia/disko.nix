{ lib, ... }: {
  disko.devices = {
#    disk = lib.genAttrs [ "nvme-WD_BLACK_SN770_2TB_23178Y402957"] "nvme-WD_BLACK_SN850X_2000GB_24171U802988" ] (name: {
    disk = {
      nvme0 = {
        type = "disk";
        device = "/dev/disk/by-id/nvme-WD_BLACK_SN770_2TB_23178Y402957";
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
            mdadm = {
              size = "100%";
              content = {
                type = "mdraid";
                name = "main_raid1";
              };
            };
          };
        };
      };
    };

    mdadm.main_raid1 = {
      type = "mdadm";
      level = 1;
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
    
    lvm_vg = {
      main = {
        type = "lvm_vg";
        lvs = {
          root = {
            size = "200G";
            content = {
              type = "filesystem";
              format = "xfs";
              mountOptions = [ "x-systemd.device-timeout=0" ];
              mountpoint = "/";
            };
          };
          nix = {
            size = "200G";
            content = {
              type = "filesystem";
              format = "xfs";
              mountOptions = [ "x-systemd.device-timeout=0" ];
              mountpoint = "/nix";
            };
          };
          home = {
            size = "300G";
            content = {
              type = "filesystem";
              format = "xfs";
              mountOptions = [ "x-systemd.device-timeout=0" ];
              mountpoint = "/home";
            };
          };
        };
      };
    };
  };
}
