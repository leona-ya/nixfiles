{ pkgs, ... }:

{
  home-manager.users.leona = {
    services.kanshi = {
      enable = true;
      profiles = {
        default = {
          outputs = [
            {
              criteria = "eDP-1";
              mode = "2880x1800";
              position = "0,0";
              scale = 1.45;
            }
          ];
        };
        home = {
          outputs = [
            {
              criteria = "eDP-1";
              mode = "2880x1800";
              position = "0,0";
              scale = 1.45;
            }
            {
              criteria = "DP-1";
              mode = "3840x2160";
              position = "1986,0";
              scale = 1.3;
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
