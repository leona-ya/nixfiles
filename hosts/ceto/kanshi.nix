{ pkgs, ... }:

{
  home-manager.users.leona = {
    services.kanshi = {
      enable = true;
      settings = [
        {
          profile.name = "home";
          profile.outputs = [
            {
              criteria = "Dell Inc. DELL U3223QE FDPTDP3";
              mode = "3840x2160";
              position = "1307,363";
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
              criteria = "HDMI-A-1";
              status = "disable";
            }
          ];
          profile.exec = "${pkgs.sway}/bin/swaymsg workspace 2, move workspace to output 'Dell Inc. DELL P2423D JY45VZ3'";
        }
        {
          profile.name = "home2";
          profile.outputs = [
            {
              criteria = "Dell Inc. DELL U3223QE FDPTDP3";
              mode = "3840x2160";
              position = "1307,363";
              scale = 1.35;
            }
            {
              criteria = "Dell Inc. DELL P2423D JY45VZ3";
              mode = "2560x1440";
              position = "0,0";
              scale = 1.1;
              transform = "270";
            }
          ];
          profile.exec = "${pkgs.sway}/bin/swaymsg workspace 2, move workspace to output 'Dell Inc. DELL P2423D JY45VZ3'";
        }
      ];
    };
    wayland.windowManager.sway.config.startup = [
      {
        command = "systemctl --user restart kanshi";
        always = true;
      }
    ];
  };
}
