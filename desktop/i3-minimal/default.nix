{ config, pkgs, ... }: {
  services.xserver = {
    enable = true;
    displayManager.startx.enable = true;
  };
  home-manager.users.leona = {
    home.file.".XCompose".text = ''

    '';
    xsession.windowManager.i3 = let
      cfg = config.home-manager.users.leona.xsession.windowManager.i3;
      wallpaper = "~/.wallpapers/space2.jpg";
      modifier = "Mod4";
    in {
      enable = true;
      package = pkgs.i3-gaps;
      config = {
        fonts = {
          names = [ "JetBrains Mono" ];
          size = 8.0;
        }; # Jetbrains Mono
        terminal = "alacritty";
        menu = "rofi -show drun";

        bars = [ ];

        startup = [ ];

	gaps.inner = 10;
	
	window = {
          border = 0;
          hideEdgeBorders = "both";
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
          "${modifier}+F1" = "workspace 11";
          "${modifier}+F2" = "workspace 12";
          "${modifier}+F3" = "workspace 13";
          "${modifier}+F4" = "workspace 14";
          "${modifier}+F5" = "workspace 15";
          "${modifier}+F6" = "workspace 16";
          "${modifier}+F7" = "workspace 17";
          "${modifier}+F8" = "workspace 18";
          "${modifier}+F9" = "workspace 19";
          "${modifier}+F10" = "workspace 20";

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
          "${modifier}+Shift+F1" = "move container to workspace 11";
          "${modifier}+Shift+F2" = "move container to workspace 12";
          "${modifier}+Shift+F3" = "move container to workspace 13";
          "${modifier}+Shift+F4" = "move container to workspace 14";
          "${modifier}+Shift+F5" = "move container to workspace 15";
          "${modifier}+Shift+F6" = "move container to workspace 16";
          "${modifier}+Shift+F7" = "move container to workspace 17";
          "${modifier}+Shift+F8" = "move container to workspace 18";
          "${modifier}+Shift+F9" = "move container to workspace 19";
          "${modifier}+Shift+F10" = "move container to workspace 20";

          "XF86AudioRaiseVolume" = "exec --no-startup-id ${pkgs.pamixer}/bin/pamixer -i 5";
          "XF86AudioLowerVolume" = "exec --no-startup-id ${pkgs.pamixer}/bin/pamixer -d 5";
          "XF86AudioMute" = "exec --no-startup-id ${pkgs.pamixer}/bin/pamixer -t";
          "XF86AudioMicMute" = "exec --no-startup-id ${pkgs.pamixer}/bin/pamixer --default-source -t";

          "${modifier}+d" = "exec ${cfg.config.menu}";
          "${modifier}+p" = "exec ${pkgs.rofi-pass}/bin/rofi-pass";

          "${modifier}+Shift+c" = "reload";
          "${modifier}+Shift+e" = "exit";
          "${modifier}+Shift+q" = "kill";

          "${modifier}+r" = "mode resize";
        };
      };
      extraConfig = ''
      	exec "setxkbmap -option compose:prsc"
        client.focused #00000000 #000000B3 #FFFFFF
        client.unfocused #00000000 #00000066 #FFFFFF
        client.focused_inactive #00000000 #00000066 #FFFFFF
        # titlebar_border_thickness 3
        # titlebar_padding 8 6
      '';
    };
  };
}
