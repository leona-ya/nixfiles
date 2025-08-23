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
      extraConfig = let 
        isLinux = config.nixpkgs.hostPlatform.isLinux;
        modKey = if isLinux then "CTRL" else "CMD";
      in ''
        -- This table will hold the configuration.
        local config = {}

        -- In newer versions of wezterm, use the config_builder which will
        -- help provide clearer error messages
        if wezterm.config_builder then
          config = wezterm.config_builder()
        end

        config.window_decorations = "TITLE | RESIZE"

        config.font = wezterm.font("Monaspace Argon", { weight = 500 })
        config.font_size = ${if isLinux then "8.5" else "11"}
        config.line_height = 1.2
        config.window_frame = {
          font_size = ${if isLinux then "9" else "11"}
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

        config.scrollback_lines = 100000
        local act = wezterm.action
        config.disable_default_key_bindings = false
        config.keys = {
          { mods = "${modKey}", key = "1", action = act.ActivateTab(0) },
          { mods = "${modKey}", key = "2", action = act.ActivateTab(1) },
          { mods = "${modKey}", key = "3", action = act.ActivateTab(2) },
          { mods = "${modKey}", key = "4", action = act.ActivateTab(3) },
          { mods = "${modKey}", key = "5", action = act.ActivateTab(4) },
          { mods = "${modKey}", key = "6", action = act.ActivateTab(5) },
          { mods = "${modKey}", key = "7", action = act.ActivateTab(6) },
          { mods = "${modKey}", key = "8", action = act.ActivateTab(7) },
          { mods = "${modKey}", key = "9", action = act.ActivateTab(8) },
          { mods = "${modKey}", key = "0", action = act.ActivateTab(9) },
          { mods = "${modKey}|SHIFT", key = "LeftArrow", action = act.ActivateTabRelative(-1) },
          { mods = "${modKey}|SHIFT", key = "RightArrow", action = act.ActivateTabRelative(1) },
          { mods = "${modKey}|SHIFT", key = "q", action = act.CloseCurrentTab { confirm = true } },

          { mods = "${modKey}|SHIFT", key = "v", action = act.SplitVertical { domain = "CurrentPaneDomain" } },
          { mods = "${modKey}|SHIFT", key = "h", action = act.SplitHorizontal { domain = "CurrentPaneDomain" } },
          { mods = "${modKey}", key = "LeftArrow", action = act.ActivatePaneDirection("Left") },
          { mods = "${modKey}", key = "RightArrow", action = act.ActivatePaneDirection("Right") },
          { mods = "${modKey}", key = "UpArrow", action = act.ActivatePaneDirection("Up") },
          { mods = "${modKey}", key = "DownArrow", action = act.ActivatePaneDirection("Down") },
          { mods = "${modKey}|SHIFT", key = "w", action = act.CloseCurrentPane { confirm = false } },

          { mods = "${modKey}|SHIFT", key = "c", action = act.CopyTo("Clipboard") },
          { mods = "${modKey}|SHIFT", key = "v", action = act.PasteFrom("Clipboard") },
          { mods = "${modKey}", key = "-", action = act.DecreaseFontSize },
          { mods = "${modKey}", key = "=", action = act.IncreaseFontSize },
          { mods = "${modKey}", key = "k", action = act.ActivateCommandPalette },
          { mods = "${modKey}|SHIFT", key = "f", action = act.Search { CaseSensitiveString = ""} },
          { mods = "${modKey}", key = "t", action = act.SpawnTab("CurrentPaneDomain") },

          { mods = "${modKey}|SHIFT", key = "l", action = act.ShowDebugOverlay },
        }
        return config
      '';
    };
  };
}
