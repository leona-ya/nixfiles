
{ lib, ... }: {
  disko.devices = {
#    disk = lib.genAttrs [ "nvme-WD_BLACK_SN770_2TB_23178Y402957"] "nvme-WD_BLACK_SN850X_2000GB_24171U802988" ] (name: {
    disk = {
      nvme0 = {
        type = "disk";
        device = "/dev/nvme0n1";
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
          nix = {
            size = "150G";
            content = {
              type = "filesystem";
              format = "xfs";
              mountpoint = "/nix";
            };
          };
          home = {
            size = "200G";
            content = {
              type = "filesystem";
              format = "xfs";
              mountpoint = "/home";
            };
          };
          swap = {
            size = "32GB";
            content = {
              type = "swap";
              discardPolicy = "both";
            };
          };
        };
      };
    };
  };
}
