{ config, lib, ... }:

let
  hosthelper = import ../../hosts/helper.nix { inherit lib config; };
in
{
  imports = [
    ./prometheus.nix
    ./grafana.nix
    ./alertmanager.nix
    ./loki.nix
  ];
}
