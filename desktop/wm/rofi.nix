{ pkgs, ... }:

{
  home-manager.users.em0lar = {
    programs.rofi = {
      enable = true;
      colors = {
        window = {
          background = "argb:b3000000";
          border = "argb:582a373e";
          separator = "#c3c6c8";
        };

        rows = {
          normal = {
            background = "argb:00000000";
            foreground = "#fafbfc";
            backgroundAlt = "argb:00000000";
            highlight = {
              background = "#00bcd4";
              foreground = "#fafbfc";
            };
          };
        };
      };
      pass.enable = true;
    };
  };
}
