{ config, pkgs, modulesPath, ... }:

{
  imports = [
      "${modulesPath}/virtualisation/lxc-container.nix"
      ../../common
  ];

  networking.hostName = "ladon";
  networking.domain = "int.sig.de.em0lar.dev";
  networking.useDHCP = false;
  networking.interfaces.eth0.useDHCP = true;
  networking.useHostResolvConf = false;
  em0lar.nftables.checkIPTables = false;
}
