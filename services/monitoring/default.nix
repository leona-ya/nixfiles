{ config, ... }:

{
  imports = [
    ./prometheus.nix
    ./grafana.nix
  ];
}
