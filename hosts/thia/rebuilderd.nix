{ ... }:
{
  services.rebuilderd = {
    enable = true;
    settings.http.bind_addr = "0.0.0.0:62217";
  };

  networking.firewall.allowedTCPPorts = [ 62217 ];
}
