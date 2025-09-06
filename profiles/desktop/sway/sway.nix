{
  config,
  lib,
  pkgs,
  ...
}:

{
  hardware.graphics.enable = true;

  programs.sway.enable = true;
  programs.light.enable = true;

  users.users.leona.packages = with pkgs; [
    qt5.qtwayland
    wdisplays
    waypipe
  ];

  environment.variables.SDL_VIDEODRIVER = "wayland";
  environment.variables.QT_QPA_PLATFORM = "wayland";
  environment.variables.QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
  #environment.variables._JAVA_AWT_WM_NONREPARENTING = "1";
  environment.variables.NIXOS_OZONE_WL = "1";

  security.pam.services.swaylock.rules.auth.fprintd = {
    order = config.security.pam.services.swaylock.rules.auth.unix.order + 10;
  };

  home-manager.users.leona = {
    xdg.portal = {
      enable = true;
      extraPortals = [
        pkgs.xdg-desktop-portal-gtk
        pkgs.xdg-desktop-portal-wlr
      ];
      config = {
        sway = {
          "default" = "gtk";
          "org.freedesktop.impl.ScreenCast" = "wlr";
          "org.freedesktop.impl.Screenshot" = "wlr";
          "org.freedesktop.impl.portal.Settings" = "darkman";
          "org.freedesktop.impl.portal.Inhibit" = "none";
        };
      };
    };
    systemd.user.services.swayidle.Service.Environment = lib.mkForce [
      "PATH=/run/wrappers/bin:/home/leona/.nix-profile/bin:/etc/profiles/per-user/leona/bin:/nix/var/nix/profiles/default/bin:/run/current-system/sw/bin"
    ];
    services.swayidle =
      let
        lockCommand = "${pkgs.writeShellScript "swaylock-command" ''
          1password --lock
          ${pkgs.grim}/bin/grim -t png -l 1 /tmp/lock-screenshot.png
          ${pkgs.imagemagick}/bin/magick /tmp/lock-screenshot.png -blur 80x40 /tmp/lock-screenshot.png
          ${pkgs.swaylock}/bin/swaylock -i /tmp/lock-screenshot.png
        ''}";
      in
      {
        enable = true;
        events = [
          {
            event = "before-sleep";
            command = lockCommand;
          }
          {
            event = "lock";
            command = lockCommand;
          }
        ];
        timeouts = [
          {
            timeout = 300;
            command = lockCommand;
          }
        ];
      };
    wayland.windowManager.sway =
      let
        cfg = config.home-manager.users.leona.wayland.windowManager.sway;
        wallpaper = "~/.wallpapers/cyberpunk_1.jpg";
        modifier = "Mod4";
      in
      {
        enable = true;
        package = pkgs.sway;
        wrapperFeatures.gtk = true;
        systemd.variables = [
          "DISPLAY"
          "WAYLAND_DISPLAY"
          "SWAYSOCK"
          "XDG_CURRENT_DESKTOP"
          "XDG_SESSION_TYPE"
          "NIXOS_OZONE_WL"
          "XCURSOR_THEME"
          "XCURSOR_SIZE"
          "XDG_DATA_DIRS"
        ];

        checkConfig = false;
        config = {
          fonts = {
            names = [ "JetBrains Mono" ];
            size = 8.0;
          }; # Jetbrains Mono
          terminal = "wezterm";
          menu = "wofi --show drun";

          bars = [ ];

          window = {
            border = 0;
            hideEdgeBorders = "both";
          };
          gaps.inner = 10;

          input = {
            "*" = {
              xkb_options = "compose:caps";
            };
            "type:touchpad" = {
              tap = "enabled";
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
            "XF86MonBrightnessDown" = "exec ${pkgs.light}/bin/light -U 5";
            "XF86MonBrightnessUp" = "exec ${pkgs.light}/bin/light -A 5";

            "${modifier}+l" = "exec loginctl lock-session";
            "${modifier}+d" = "exec ${cfg.config.menu}";

            "${modifier}+Shift+c" = "reload";
            "${modifier}+Shift+e" = "exit";
            "${modifier}+Shift+q" = "kill";

            "${modifier}+r" = "mode resize";

            "${modifier}+Shift+s" =
              "exec ${pkgs.grim}/bin/grim -t png -l 1 -g \"$(${pkgs.slurp}/bin/slurp)\" ~/screenshot-$(date +%Y-%m-%d_%H-%m-%s).png";
          };
          startup = [
            {
              command = "systemctl --user restart nextcloud-client";
              always = true;
            }
          ];
        };

        extraConfig = ''
          client.focused #00000000 #000000cc #FFFFFF
          client.unfocused #00000000 #00000070 #FFFFFF
          client.focused_inactive #00000000 #00000090 #FFFFFF
          titlebar_border_thickness 3
          titlebar_padding 8 6
          include ~/.config/sway/config-current-theme
        '';
      };
    xdg.configFile."sway/config-light-theme" = {
      text = ''
        output "*" {
          bg ~/.wallpapers/nixos-catppucin-latte.png fill
        }
      '';
    };
    xdg.configFile."sway/config-dark-theme" = {
      text = ''
        output "*" {
          bg ~/.wallpapers/nixos-catppucin-mocha.png fill
        }
      '';
    };
    services.darkman = {
      darkModeScripts.sway = ''
        ${pkgs.coreutils}/bin/ln -fs config-dark-theme ~/.config/sway/config-current-theme
        ${pkgs.sway}/bin/swaymsg reload
      '';
      lightModeScripts.sway = ''
        ${pkgs.coreutils}/bin/ln -fs config-light-theme ~/.config/sway/config-current-theme
        ${pkgs.sway}/bin/swaymsg reload
      '';
    };
  };
}
