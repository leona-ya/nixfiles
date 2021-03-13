{ config, pkgs, modulesPath, ... }:

{
  imports = [
      "${modulesPath}/virtualisation/lxc-container.nix"
      ./wireguard.nix
      ../../common
      ../../services/gitea
      ../../services/hedgedoc
      ../../services/matrix
  ];

  networking.hostName = "beryl";
  networking.domain = "int.sig.de.em0lar.dev";
  systemd.network.networks."10-eth0" = {
    DHCP = "yes";
    matchConfig = {
      Name = "eth0";
    };
  };
  networking.useHostResolvConf = false;
  em0lar.nftables.checkIPTables = false;
}
