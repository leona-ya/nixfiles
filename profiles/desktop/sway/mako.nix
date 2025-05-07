{ config, pkgs, ... }:

let
  swayConfig = config.home-manager.users.leona.wayland.windowManager.sway.config;
in
{
  users.users.leona.packages = with pkgs; [ mako ];
  home-manager.users.leona = {
    services.mako = {
      enable = true;
      settings = {
        defaultTimeout = 10000;
        borderColor = "#ffffff";
        backgroundColor = "#00000070";
        textColor = "#ffffff";
      };
    };
    wayland.windowManager.sway.config.startup = [{
      command = "${pkgs.mako}/bin/mako";
      always = false;
    }];
  };
}
