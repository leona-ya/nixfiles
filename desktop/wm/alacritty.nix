# inspired by petabyteboy (git.petabyte.dev/petabyteboy/nixfiles)
{ ... }:

{
  home-manager.users.em0lar = {
    programs.alacritty = {
      enable = true;
      settings = {
        font.normal = {
          family = "JetBrains Mono";
          size = 9.0;
        };

        colors = {
          primary = {
            background = "#000000";
            foreground = "#eaeaea";
          };

          normal = {
            black = "#6c6c6c";
            red = "#e9897c";
            green = "#b6e77d";
            yellow = "#ecebbe";
            blue = "#a9cdeb";
            magenta = "#ea96eb";
            cyan = "#c9caec";
            white = "#f2f2f2";
          };

          bright = {
            black = "#747474";
            red = "#f99286";
            green = "#c3f786";
            yellow = "#fcfbcc";
            blue = "#b6defb";
            magenta = "#fba1fb";
            cyan = "#d7d9fc";
            white = "#e2e2e2";
          };
        };

        window.opacity = 0.7;
      };
    };
  };
}
