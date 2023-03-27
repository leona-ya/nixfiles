{ ... }:

{
  home-manager.users.leona = {
    programs.alacritty = {
      enable = true;
      settings = {
        font = {
          normal = {
            family = "JetBrains Mono";
          };
          size = 9.0;
        };

        window.padding = {
          x = 10;
          y = 10;
        };

        colors = {
          # Default colors
          primary = {
            background = "#2D2A2E";
            foreground = "#FCFCFA";
          };
          # Normal colors
          normal = {
            black = "#403E41";
            red = "#FF6188";
            green = "#A9DC76";
            yellow = "#FFD866";
            blue = "#FC9867";
            magenta = "#AB9DF2";
            cyan = "#78DCE8";
            white = "#FCFCFA";
          };
          # Bright colors
          bright = {
            black = "#727072";
            red = "#FF6188";
            green = "#A9DC76";
            yellow = "#FFD866";
            blue = "#FC9867";
            magenta = "#AB9DF2";
            cyan = "#78DCE8";
            white = "#FCFCFA";
          };
        };
      };
    };
  };
}
