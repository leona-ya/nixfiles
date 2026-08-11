{ ... }: {
  services.unifi = {
    enable = true;
    openFirewall = true;
  };

  networking.firewall.interfaces."br-clients".allowedTCPPorts = [ 8443 ];
}
