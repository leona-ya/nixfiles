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

  networking.hostName = "nyan";
  networking.domain = "net.leona.is";

  environment.etc."mdadm.conf".text = ''
    HOMEHOST <ignore>
    MAILADDR noc@leona.is
  '';
  boot.initrd.mdadmConf = config.environment.etc."mdadm.conf".text;

  l.nftables.checkIPTables = false;
  virtualisation.libvirtd.enable = true;

  l.telegraf = {
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


