{ config, pkgs, modulesPath, ... }:

{
  imports = [
      "${modulesPath}/virtualisation/lxc-container.nix"
      ./wireguard.nix
      ../../common
      ../../services/gitea
  ];

  networking.hostName = "beryl";
  networking.domain = "int.sig.de.em0lar.dev";
  services.resolved.dnssec = "false"; # dnssec check is already done on other dns server
  systemd.network.networks."10-eth0" = {
    DHCP = "yes";
    matchConfig = {
      Name = "eth0";
    };
  };
  networking.useHostResolvConf = false;
  em0lar.nftables.checkIPTables = false;
}
