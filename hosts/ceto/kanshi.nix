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
              criteria = "Lenovo Group Limited Pro 32UD-10 *";
              mode = "3840x2160";
              position = "0,320";
              scale = 1.2;
            }
            {
              criteria = "Lenovo Group Limited Pro 27UD-10 *";
              mode = "3840x2160";
              position = "3200,0";
              scale = 1.5;
              transform = "270";
            }
          ];
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
