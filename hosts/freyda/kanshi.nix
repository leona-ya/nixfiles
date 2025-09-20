{ pkgs, ... }:

{
  home-manager.users.leona = {
    services.kanshi = {
      enable = true;
      profiles = {
        home = {
          outputs = [
            {
              criteria = "Dell Inc. DELL U3223QE FDPTDP3";
              mode = "3840x2160";
              position = "1309,363";
              scale = 1.35;
            }
            {
              criteria = "Dell Inc. DELL P2423D JY45VZ3";
              mode = "2560x1440";
              position = "0,0";
              scale = 1.1;
              transform = "270";
            }
            {
              criteria = "eDP-1";
              mode = "2256x1504";
              position = "4153,500";
              scale = 1.2;
            }
          ];
          exec = "${pkgs.sway}/bin/swaymsg workspace 2, move workspace to output 'Dell Inc. DELL P2423D JY45VZ3'";
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
