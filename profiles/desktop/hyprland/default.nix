{ lib, pkgs, ... }: let
  plugins = [];
in {
  imports = [
    ./rofi.nix
    ./waybar.nix
  ];
  users.users.leona.packages = with pkgs; [ hyprland hyprpaper ];
  home-manager.users.leona = {
    services.swayidle = let
      lockCommand = "${pkgs.swaylock-effects}/bin/swaylock --screenshots --clock --effect-blur 20x10";
    in {
      enable = true;
      events = [
        { event = "before-sleep"; command = lockCommand; }
        { event = "lock"; command = lockCommand; }
      ];
      timeouts = [
#        { timeout = 300; command = lockCommand; }
      ];
    };
    xdg.configFile."hypr/hyprpaper.conf" = {
      text = ''
        preload = /home/leona/.wallpapers/trans-estro.png

        wallpaper = ,/home/leona/.wallpapers/trans-estro.png
      '';
    };
    xdg.configFile."hypr/hyprland.conf" = {
      text = ''
        exec-once=${pkgs.dbus}/bin/dbus-update-activation-environment --systemd DISPLAY WAYLAND_DISPLAY HYPRLAND_INSTANCE_SIGNATURE XDG_CURRENT_DESKTOP && systemctl --user start hyprland-session.target
      '' + lib.concatStrings (builtins.map (entry: let
          plugin = if lib.types.package.check entry then "${entry}/lib/lib${entry.pname}.so" else entry;
        in "plugin=${plugin}\n") plugins)
      + ''
        exec-once=${pkgs.waybar}/bin/waybar
        exec=hyprpaper
        misc {
          disable_hyprland_logo = true
        }
        monitor=,preferred,auto,auto
        monitor=eDP-1,preferred,0x0,1
      
        input {
          kb_layout=us
          follow_mouse=1
          kb_options=compose:prsc
          touchpad {
            natural_scroll=false
          }
        }
        gestures {
          workspace_swipe=true
          workspace_swipe_numbered=true
        }

        bind=SUPER, RETURN, exec, alacritty
        bind=SUPER_SHIFT, Q, killactive,
        bind=SUPER_SHIFT, E, exit,
        bind=SUPER, V, togglefloating,
        bind=SUPER, D, exec, rofi -show drun
        bind=SUPER, F, fullscreen,
        bind=SUPER, L, exec, loginctl lock-session

        bind=SUPER, code:112, changegroupactive, b
        bind=SUPER, code:117, changegroupactive, f
        bind=SUPER_SHIFT, code:112, moveintogroup, l
        bind=SUPER_SHIFT, code:117, moveoutofgroup,
        bind=SUPER, T, togglegroup,
        bind=SUPER, left, movefocus, l
        bind=SUPER, right, movefocus, r
        bind=SUPER, down, movefocus, d
        bind=SUPER, up, movefocus, u
        bind=SUPER_SHIFT, left, movewindow, l
        bind=SUPER_SHIFT, right, movewindow, r
        bind=SUPER_SHIFT, down, movewindow, d
        bind=SUPER_SHIFT, up, movewindow, u

        bind=SUPER, 1, workspace, 1
        bind=SUPER, 2, workspace, 2
        bind=SUPER, 3, workspace, 3
        bind=SUPER, 4, workspace, 4
        bind=SUPER, 5, workspace, 5
        bind=SUPER, 6, workspace, 6
        bind=SUPER, 7, workspace, 7
        bind=SUPER, 8, workspace, 8
        bind=SUPER, 9, workspace, 9
        bind=SUPER, 0, workspace, 10
        bind=SUPER, F1, workspace, 11
        bind=SUPER, F2, workspace, 12
        bind=SUPER, F3, workspace, 13
        bind=SUPER, F4, workspace, 14
        bind=SUPER, F5, workspace, 15
        bind=SUPER, F6, workspace, 16
        bind=SUPER, F7, workspace, 17
        bind=SUPER, F8, workspace, 18
        bind=SUPER, F9, workspace, 19
        bind=SUPER, F0, workspace, 20

        bind=SUPER_SHIFT,1,movetoworkspace,1
        bind=SUPER_SHIFT,2,movetoworkspace,2
        bind=SUPER_SHIFT,3,movetoworkspace,3
        bind=SUPER_SHIFT,4,movetoworkspace,4
        bind=SUPER_SHIFT,5,movetoworkspace,5
        bind=SUPER_SHIFT,6,movetoworkspace,6
        bind=SUPER_SHIFT,7,movetoworkspace,7
        bind=SUPER_SHIFT,8,movetoworkspace,8
        bind=SUPER_SHIFT,9,movetoworkspace,9
        bind=SUPER_SHIFT,0,movetoworkspace,10
        bind=SUPER_SHIFT,F1,movetoworkspace,11
        bind=SUPER_SHIFT,F2,movetoworkspace,12
        bind=SUPER_SHIFT,F3,movetoworkspace,13
        bind=SUPER_SHIFT,F4,movetoworkspace,14
        bind=SUPER_SHIFT,F5,movetoworkspace,15
        bind=SUPER_SHIFT,F6,movetoworkspace,16
        bind=SUPER_SHIFT,F7,movetoworkspace,17
        bind=SUPER_SHIFT,F8,movetoworkspace,18
        bind=SUPER_SHIFT,F9,movetoworkspace,19
        bind=SUPER_SHIFT,F0,movetoworkspace,20

        bindel=, XF86AudioRaiseVolume, exec, ${pkgs.pamixer}/bin/pamixer -i 5
        bindel=, XF86AudioLowerVolume, exec, ${pkgs.pamixer}/bin/pamixer -d 5
        bind=, XF86AudioMute, exec, ${pkgs.pamixer}/bin/pamixer -t
        bindel=, XF86MonBrightnessUp, exec, ${pkgs.light}/bin/light -A 5
        bindel=, XF86MonBrightnessDown, exec, ${pkgs.light}/bin/light -U 5
      '';

#      onChange = ''
#        (  # execute in subshell so that `shopt` won't affect other scripts
#          shopt -s nullglob  # so that nothing is done if /tmp/hypr/ does not exist or is empty
#          for instance in /tmp/hypr/*; do
#            HYPRLAND_INSTANCE_SIGNATURE=''${instance##*/} ${pkgs.hyprland}/bin/hyprctl reload config-only \
#              || true  # ignore dead instance(s)
#          done
#        )
#      '';
    };


    systemd.user.targets.hyprland-session = {
      Unit = {
        Description = "Hyprland compositor session";
        Documentation = ["man:systemd.special(7)"];
        BindsTo = ["graphical-session.target"];
        Wants = ["graphical-session-pre.target"];
        After = ["graphical-session-pre.target"];
      };
    };
  };
}
