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
            command = "${pkgs.python3Packages.python-lsp-server}/bin/pylsp";
          };
        }
      ];
    };
  };
}
