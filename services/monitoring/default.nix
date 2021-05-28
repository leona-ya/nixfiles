{ config, ... }:

{
  imports = [
    ./prometheus.nix
    ./grafana.nix
    ./alertmanager.nix
    ./alertmanager-bot.nix
  ];

  em0lar.telegraf.extraInputs = {
    http_response = {
      interval = "90s";
      urls = [
        "https://matrix.labcode.de/health"
        "https://labcode.de/.well-known/matrix/server"
        "https://em0lar.dev"
        "https://git.em0lar.dev"
        "https://altenforst.de"
      ];
    };
  };
}
