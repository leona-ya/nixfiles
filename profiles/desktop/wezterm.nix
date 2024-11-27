{ config, pkgs, ... }: {
  home-manager.users.leona = {
    programs.wezterm = {
      enable = true;
      colorSchemes = {
        monokai_pro = {
          ansi = [
            "#403E41" # black
            "#FF6188" # red
            "#A9DC76" # green
            "#FFD866" # yellow
            "#FC9867" # blue (orange)
            "#AB9DF2" # magenta (violet)
            "#78DCE8" # cyan
            "#FCFCFA" # foreground
          ];
          brights = [
            "#727072"
            "#FF6188"
            "#A9DC76"
            "#FFD866"
            "#FC9867"
            "#AB9DF2"
            "#78DCE8"
            "#FCFCFA"
          ];
          background = "#2D2A2E";
          #cursor_bg = "#BEAF8A";
          #cursor_border = "#BEAF8A";
          #cursor_fg = "#1B1B1B";
          foreground = "#FCFCFA";
          selection_bg = "#69616B";
          selection_fg = "#FCFCFA";
        };
        monokai_pro_light = {
          ansi = [
            "#D3CDCC" # black
            "#E14775" # red
            "#269D69" # green
            "#CC7A0A" # yellow
            "#E16032" # blue
            "#7058BE" # magenta
            "#1C8CA8" # cyan
            "#29242A" # foreground
          ];
          brights = [
            "#A59FA0" 
            "#E14775"
            "#269D69"
            "#CC7A0A"
            "#E16032"
            "#7058BE"
            "#1C8CA8"
            "#29242A"
          ];
          background = "#faf4f2";
          #cursor_bg = "#BEAF8A";
          #cursor_border = "#BEAF8A";
          #cursor_fg = "#1B1B1B";
          foreground = "#29242A";
          selection_bg = "#69616B";
          selection_fg = "#FCFCFA";
        };
      };
      extraConfig = ''
        -- This table will hold the configuration.
        local config = {}

        -- In newer versions of wezterm, use the config_builder which will
        -- help provide clearer error messages
        if wezterm.config_builder then
          config = wezterm.config_builder()
        end

        -- workaround rendering bug
        config.front_end = "WebGpu"

        config.font = wezterm.font("Monaspace Argon", { weight = 500 })
        config.font_size = 8.5
        config.line_height = 1.2
        config.window_frame = {
          font_size = 9
        }
        function color_scheme()
          local appearance = wezterm.gui.get_appearance()
          if appearance:find 'Dark' then
            return 'monokai_pro'
          else
            return 'monokai_pro_light'
          end
        end
        config.color_scheme = color_scheme()

        local act = wezterm.action
        config.disable_default_key_bindings = true
        config.keys = { 
          { mods = "CTRL", key = "1", action = act.ActivateTab(0) },
          { mods = "CTRL", key = "2", action = act.ActivateTab(1) },
          { mods = "CTRL", key = "3", action = act.ActivateTab(2) },
          { mods = "CTRL", key = "4", action = act.ActivateTab(3) },
          { mods = "CTRL", key = "5", action = act.ActivateTab(4) },
          { mods = "CTRL", key = "6", action = act.ActivateTab(5) },
          { mods = "CTRL", key = "7", action = act.ActivateTab(6) },
          { mods = "CTRL", key = "8", action = act.ActivateTab(7) },
          { mods = "CTRL", key = "9", action = act.ActivateTab(8) },
          { mods = "CTRL", key = "0", action = act.ActivateTab(9) },
          { mods = "CTRL|SHIFT", key = "LeftArrow", action = act.ActivateTabRelative(-1) },
          { mods = "CTRL|SHIFT", key = "RightArrow", action = act.ActivateTabRelative(1) },
          { mods = "CTRL|SHIFT", key = "q", action = act.CloseCurrentTab { confirm = true } },

          { mods = "CTRL|SHIFT", key = "v", action = act.SplitVertical { domain = "CurrentPaneDomain" } },
          { mods = "CTRL|SHIFT", key = "h", action = act.SplitHorizontal { domain = "CurrentPaneDomain" } },
          { mods = "CTRL", key = "LeftArrow", action = act.ActivatePaneDirection("Left") },
          { mods = "CTRL", key = "RightArrow", action = act.ActivatePaneDirection("Right") },
          { mods = "CTRL", key = "UpArrow", action = act.ActivatePaneDirection("Up") },
          { mods = "CTRL", key = "DownArrow", action = act.ActivatePaneDirection("Down") },
          { mods = "CTRL|SHIFT", key = "w", action = act.CloseCurrentPane { confirm = false } },

          { mods = "CTRL|SHIFT", key = "c", action = act.CopyTo("Clipboard") },
          { mods = "CTRL|SHIFT", key = "v", action = act.PasteFrom("Clipboard") },
          { mods = "CTRL", key = "-", action = act.DecreaseFontSize },
          { mods = "CTRL", key = "=", action = act.IncreaseFontSize },
          { mods = "CTRL", key = "k", action = act.ActivateCommandPalette },
          { mods = "CTRL|SHIFT", key = "f", action = act.Search { CaseSensitiveString = ""} },
          { mods = "CTRL", key = "t", action = act.SpawnTab("CurrentPaneDomain") },

          { mods = "CTRL|SHIFT", key = "l", action = act.ShowDebugOverlay },
        }
        return config
      '';
    };
  };
}
