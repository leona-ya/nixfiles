{ ... }: {
  services.unifi = {
    enable = true;
    openFirewall = true;
  };

  networking.firewall.interfaces."eth-rcy".allowedTCPPorts = [ 8443 ];
}
