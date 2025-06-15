{ config, lib, pkgs, ... }:

{
  users.users.leona.packages = [ pkgs.waybar ];
  home-manager.users.leona = {
    xdg.configFile."waybar/config".source = ./waybar-config.json;
    xdg.configFile."waybar/style.css".source = ./waybar-style.css;
    wayland.windowManager.sway.config.startup = [{
      command = "${pkgs.waybar}/bin/waybar";
      always = false;
    }];
  };
}

