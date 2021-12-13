{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./networking
    ../../common
  ];

  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.devices = [ "/dev/sda" "/dev/sdb" ]; # or "nodev" for efi only

  networking.hostName = "nyo";
  networking.domain = "net.em0lar.dev";

  environment.etc."mdadm.conf".text = ''
    HOMEHOST <ignore>
  '';
  boot.initrd.mdadmConf = config.environment.etc."mdadm.conf".text;

  em0lar.nftables.checkIPTables = false;
  virtualisation.libvirtd.enable = true;

  em0lar.telegraf = {
    enable = true;
    host = "[fd8f:d15b:9f40:0c30::1]";
    diskioDisks = [ "sda" "sdb" ];
    extraInputs = {
      mdstat = { };
    };
  };
  services.telegraf.extraConfig.inputs.net.interfaces = [ "br*" "wg-*" "eth0" ];

  system.stateVersion = "22.05";
}


