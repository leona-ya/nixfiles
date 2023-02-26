{ pkgs, ... }: {
  home-manager.users.leona = {
    programs.helix = {
      enable = true;
      settings = {
        theme = "monokai";
      };
      languages = [
        {
          name = "nix";
          language-server = {
            command = "${pkgs.nil}/bin/nil";
          };
        }
        {
          name = "python";
          language-server = {
            command = "pylsp";
          };
        }
        {
          name = "rust";
          language-server = {
            command = "${pkgs.rust-analyzer}/bin/rust-analyzer";
          };
        }
      ];
    };
  };
  environment.systemPackages = [    
    (pkgs.python3.withPackages(ps: [ ps.python-lsp-server ] ++ ps.python-lsp-server.optional-dependencies.all ))
  ];
}
