{
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = "/dev/vda";
        content = {
          type = "gpt";
          partitions = {
            boot = {
              size = "1M";
              type = "EF02"; # for grub MBR
            };
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
                name = "crypted";
                extraOpenArgs = [ ];
                settings = {
                  allowDiscards = true;
                };
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
        };
      };
    };
  };
}
