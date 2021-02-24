{ config, pkgs, ... }:

let
  swayConfig = config.home-manager.users.em0lar.wayland.windowManager.sway.config;
in {
  users.users.em0lar.packages = with pkgs; [ mako ];
  home-manager.users.em0lar = {
    programs.mako = {
      enable = true;
      defaultTimeout = 10000;
      borderColor = "#ffffff";
      backgroundColor = "#00000070";
      textColor = "#ffffff";
    };
    wayland.windowManager.sway.config.startup = [{
      command = "${pkgs.mako}/bin/mako";
      always = false;
    }];
  };
}
