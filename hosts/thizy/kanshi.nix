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
