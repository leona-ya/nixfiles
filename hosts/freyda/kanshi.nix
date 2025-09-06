{ pkgs, ... }:

{
  home-manager.users.leona = {
    services.kanshi = {
      enable = true;
      profiles = {
        home = {
          outputs = [
            {
              criteria = "eDP-1";
              mode = "2256x1504";
              position = "1128,1200";
              scale = 1.2;
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
          outputs = [
            {
              criteria = "eDP-1";
              mode = "2256x1504";
              position = "1128,1200";
              scale = 1.2;
            }
          ];
        };
      };
    };
    wayland.windowManager.sway.config.startup = [
      {
        command = "systemctl --user restart kanshi";
        always = true;
      }
    ];
  };
}
