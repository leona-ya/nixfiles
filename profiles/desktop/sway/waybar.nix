{ config, lib, pkgs, ... }:

let
  waybar = pkgs.waybar.override {
    hyprlandSupport = false;
  };
in
{
  users.users.leona.packages = [ waybar ];
  home-manager.users.leona = {
    xdg.configFile."waybar/config".source = ./waybar-config.json;
    xdg.configFile."waybar/style.css".source = ./waybar-style.css;
    wayland.windowManager.sway.config.startup = [{
      command = "${waybar}/bin/waybar";
      always = false;
    }];
  };
}

