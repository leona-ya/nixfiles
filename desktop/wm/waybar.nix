{ config, lib, pkgs, ... }:

let
  cfg = config.services.waybar;
  styles = ./waybar-style.css;
  configFile = pkgs.writeText "waybar-config.json" (builtins.toJSON cfg.config);
in {
  users.users.em0lar.packages = with pkgs; [ waybar ];
  home-manager.users.em0lar = {
    xdg.configFile."waybar/config".source = ./waybar-config.json;
    xdg.configFile."waybar/style.css".source = ./waybar-style.css;
    wayland.windowManager.sway.config.startup = [{
      command = "${pkgs.waybar}/bin/waybar";
      always = false;
    }];
  };
}

