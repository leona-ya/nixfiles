{ pkgs, ... }: {
  home-manager.users.leona = {
    programs.helix = {
      enable = true;
      settings = {
        theme = "monokai";
        editor.soft-wrap = {
          enable = true;
          max-wrap = 25; # increase value to reduce forced mid-word wrapping
          max-indent-retain = 0;
          wrap-indicator = "";  # set wrap-indicator to "" to hide it
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
                args = ["-xelatex" "-interaction=nonstopmode" "-synctex=1" "%f"];
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
            language-servers = [ "rust-analyzer"];
          }
          {
            name = "latex";
            language-servers = [ "texlab" ];
          }
        ];
      };
    };
  };
  environment.systemPackages = [    
    (pkgs.python3.withPackages(ps: [ ps.python-lsp-server ] ++ ps.python-lsp-server.optional-dependencies.all ))
  ];
}
