{ config, lib, ... }:

let
  hosthelper = import ../../hosts/helper.nix { inherit lib config; };
in
{
  imports = [
    ./grafana.nix
    ./vm.nix
  ];
}
