{ pkgs, ... }:
{
  imports = [
    ../../../services/dns-kresd
  ];
  services.resolved.enable = false;
  services.kresd = {
    listenPlain = [
      "127.0.0.1:53"
      "[::1]:53"
      "10.151.4.1:53"
      "[fd8f:d15b:9f40:101::1]:53"
    ];
  };
}
