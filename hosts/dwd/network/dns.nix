{ pkgs, ... }: {
  imports = [
    ../../../services/dns-kresd
  ];
  services.resolved.enable = false;
  services.kresd = {
    listenPlain = [
      "127.0.0.1:53"
      "[::1]:53"
      "10.151.4.1:53"
    ];
  };

  l.telegraf.extraInputs = {
    prometheus = {
      urls = [ "http://127.0.0.1:8453/metrics" ];
      metric_version = 2;
    };
  };
}
