{ config, lib, pkgs, ... }:

{
  hardware.opengl.enable = true;

  programs.sway.enable = true;
  programs.light.enable = true;

  users.users.em0lar.packages = with pkgs; [
    grim
    qt5.qtwayland
    slurp
    wdisplays
  ];

  environment.variables.SDL_VIDEODRIVER = "wayland";
  environment.variables.QT_QPA_PLATFORM = "wayland";
  environment.variables.QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
  environment.variables._JAVA_AWT_WM_NONREPARENTING = "1";

  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-wlr ];

  home-manager.users.em0lar = {
    wayland.windowManager.sway = let
      cfg = config.home-manager.users.em0lar.wayland.windowManager.sway;
      wallpaper = "~/.wallpapers/pbb/river.png";
      lockCommand = "swaylock -i ${wallpaper}";
      modifier = "Mod4";
    in {
      enable = true;
      package = pkgs.sway;
      wrapperFeatures.gtk = true;

      config = {
        fonts = {
          names = [ "JetBrains Mono" ];
          size = 8.0;
        }; # Jetbrains Mono
        terminal = "alacritty";
        menu = "rofi -show drun";

        bars = [ ];

        startup = [ ];

        output = {
          "*" = {
            bg = "${wallpaper} fill";
          };
        };

        input = {
          "*" = {
            xkb_options = "compose:prsc";
          };
        };

        keybindings = {
          "${modifier}+Return" = "exec ${cfg.config.terminal}";

          "${modifier}+Left" = "focus left";
          "${modifier}+Down" = "focus down";
          "${modifier}+Up" = "focus up";
          "${modifier}+Right" = "focus right";

          "${modifier}+Shift+Left" = "move left";
          "${modifier}+Shift+Down" = "move down";
          "${modifier}+Shift+Up" = "move up";
          "${modifier}+Shift+Right" = "move right";

          "${modifier}+h" = "split h";
          "${modifier}+v" = "split v";

          "${modifier}+s" = "layout stacked";
          "${modifier}+w" = "layout tabbed";

          "${modifier}+Shift+space" = "floating toggle";
          "${modifier}+space" = "focus mode_toggle";
          "${modifier}+a" = "focus parent";

          "${modifier}+f" = "fullscreen toggle";

          "${modifier}+1" = "workspace 1";
          "${modifier}+2" = "workspace 2";
          "${modifier}+3" = "workspace 3";
          "${modifier}+4" = "workspace 4";
          "${modifier}+5" = "workspace 5";
          "${modifier}+6" = "workspace 6";
          "${modifier}+7" = "workspace 7";
          "${modifier}+8" = "workspace 8";
          "${modifier}+9" = "workspace 9";
          "${modifier}+0" = "workspace 10";

          "${modifier}+Shift+1" = "move container to workspace 1";
          "${modifier}+Shift+2" = "move container to workspace 2";
          "${modifier}+Shift+3" = "move container to workspace 3";
          "${modifier}+Shift+4" = "move container to workspace 4";
          "${modifier}+Shift+5" = "move container to workspace 5";
          "${modifier}+Shift+6" = "move container to workspace 6";
          "${modifier}+Shift+7" = "move container to workspace 7";
          "${modifier}+Shift+8" = "move container to workspace 8";
          "${modifier}+Shift+9" = "move container to workspace 9";
          "${modifier}+Shift+0" = "move container to workspace 10";

          "XF86AudioRaiseVolume" = "exec --no-startup-id ${pkgs.pamixer}/bin/pamixer -i 5";
          "XF86AudioLowerVolume" = "exec --no-startup-id ${pkgs.pamixer}/bin/pamixer -d 5";
          "XF86AudioMute" = "exec --no-startup-id ${pkgs.pamixer}/bin/pamixer -t";
          "XF86AudioMicMute" = "exec --no-startup-id ${pkgs.pamixer}/bin/pamixer --default-source -t";
          "XF86MonBrightnessDown" = "exec ${pkgs.light}/bin/light -U 5";
          "XF86MonBrightnessUp" = "exec ${pkgs.light}/bin/light -A 5";

          "${modifier}+l" = "exec ${lockCommand}";
          "${modifier}+d" = "exec ${cfg.config.menu}";
          "${modifier}+p" = "exec ${pkgs.rofi-pass}/bin/rofi-pass";

          "${modifier}+Shift+c" = "reload";
          "${modifier}+Shift+e" = "exit";
          "${modifier}+Shift+q" = "kill";

          "${modifier}+r" = "mode resize";
        };
      };
    };
    programs.zsh.initExtra = ''
      if [ "$(tty)" = "/dev/tty1" ]; then
        exec sway
      fi
    '';
  };
}
