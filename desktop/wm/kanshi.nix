{ pkgs, ... }:

{
  home-manager.users.em0lar = {
    services.kanshi = {
      enable = true;
      profiles = {
        home = {
          outputs = [
            {
              criteria = "eDP-1";
              mode = "1920x1080";
              position = "960,1200";
            }
            {
              criteria = "DP-2";
              mode = "3840x1200";
              position = "0,0";
            }
          ];
          exec = "${pkgs.sway}/bin/swaymsg workspace 2, move workspace to output DP-2";
        };
        default = {
          outputs = [{
            criteria = "eDP-1";
            mode = "1920x1080";
            position = "0,0";
          }];
        };
      };
    };
    wayland.windowManager.sway.config.startup = [{
      command = "systemctl --user restart kanshi";
      always = true;
    }];
  };
}
