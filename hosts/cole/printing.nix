{ pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;
  services.printing = {
    enable = true;
    drivers = [ pkgs.samsung-unified-linux-driver_4_01_17 ];
  };
}

