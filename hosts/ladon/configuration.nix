{ config, pkgs, modulesPath, lib, ... }:

{
  imports = [
      "${modulesPath}/virtualisation/lxc-container.nix"
      ../../common
      ../../services/ldap
      ../../services/keycloak
  ];

  environment.noXlibs = lib.mkForce false;
  networking.hostName = "ladon";
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
  networking.firewall.interfaces.eth0.allowedTCPPorts = [ 389  636 ];
}
