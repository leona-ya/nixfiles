{ config, ... }:

{
  imports = [
    ./prometheus.nix
    ./grafana.nix
    ./alertmanager.nix
    ./alertmanager-bot.nix
  ];
}
