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
              position = "0,0";
              scale = 1.35;
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
