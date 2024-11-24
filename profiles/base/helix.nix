{ config, lib, pkgs, ... }: {
  home-manager.users.leona = {
    programs.helix = {
      enable = true;
      settings = {
        editor.soft-wrap = {
          enable = true;
          max-wrap = 25; # increase value to reduce forced mid-word wrapping
          max-indent-retain = 0;
          wrap-indicator = ""; # set wrap-indicator to "" to hide it
        };
      };
      themes = {
        monokai_pro_transparent = {
          inherits = "monokai_pro";
          "ui.background" = { };
        };
        monokai_pro_light_transparent = {
          inherits = "monokai_pro";
          "ui.background" = { };
          special = "orange";
          module = "orange";
          "variable.parameter" = "orange";
          palette = {
            red = "#e14775";
            orange = "#e16032";
            yellow = "#cc7a0a";
            green = "#269d69";
            blue = "#1c8ca8";
            purple = "#7058be";
            # base colors, sorted from darkest to lightest
            base0 = "#f6f4f4";
            base1 = "#eceae9";
            base2 = "#e3dfde";
            base3 = "#faf4f2";
            base4 = "#bdb4b2";
            base5 = "#a19f91";
            base6 = "#796b67";
            base7 = "#37312f";
            base8 = "#29242a";
            base8x0c = "#e3dfde";
          };
        };
      };
      languages = {
        language-server = {
          nil = { command = "${pkgs.nil}/bin/nil"; };
          pylsp = { command = "pylsp"; };
          rust-analyzer = {
            command = "${pkgs.rust-analyzer}/bin/rust-analyzer";
            config."rust-analyzer" = {
              cargo = {
                buildScripts = {
                  enable = true;
                };
              };
              procMacro = {
                enable = true;
              };
            };
          };
          texlab = {
            config.texlab = {
              build = {
                onSave = true;
                args = [ "-xelatex" "-interaction=nonstopmode" "-synctex=1" "%f" ];
                #executable = "tectonic";
                #args = [
                #"-X"
                #"compile"
                #"%f"
                #"--synctex"
                #"--keep-logs"
                #"--keep-intermediates"
                #];
              };
            };
          };
        };
        language = [
          {
            name = "nix";
            language-servers = [ "nil" ];
          }
          {
            name = "python";
            language-servers = [ "pylsp" ];
          }
          {
            name = "rust";
            language-servers = [ "rust-analyzer" ];
          }
          {
            name = "latex";
            language-servers = [ "texlab" ];
          }
        ];
      };
    };
    xdg.configFile = let
      cfg = config.home-manager.users.leona.programs.helix;
      tomlFormat = pkgs.formats.toml { };
    in {
      "helix/config.toml".enable = false;
      "helix/config-light-theme.toml".source = tomlFormat.generate "helix-config-light" (cfg.settings // { theme = "monokai_pro_light_transparent"; });
      "helix/config-dark-theme.toml".source = tomlFormat.generate "helix-config-dark" (cfg.settings // { theme = "monokai_pro_transparent"; });
    };
    services.darkman = {
      darkModeScripts.helix = ''
        ${pkgs.coreutils}/bin/ln -fs config-dark-theme.toml ~/.config/helix/config.toml
        ${pkgs.procps}/bin/pkill -USR1 hx
      '';
      lightModeScripts.helix = ''
        ${pkgs.coreutils}/bin/ln -fs config-light-theme.toml ~/.config/helix/config.toml
        ${pkgs.procps}/bin/pkill -USR1 hx
      '';
    };
  };
  environment.systemPackages = [
    (pkgs.python3.withPackages (ps: [ ps.python-lsp-server ] ++ ps.python-lsp-server.optional-dependencies.all))
  ];
}
