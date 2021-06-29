{ pkgs, lib, config, ... }:

{
  em0lar.secrets.global-user-root-password.source-path = "${../../secrets/all/user-root-password.gpg}";

  users.users.root = {
    shell = pkgs.zsh;
    passwordFile = config.em0lar.secrets.global-user-root-password.path;
  };

  home-manager.users.root = {
    # prevent ifd
    manual.manpages.enable = false;

    programs.zsh = {
      enable = true;
      plugins = [{
        name = "zsh-nix-shell";
        file = "nix-shell.plugin.zsh";
        src = pkgs.fetchFromGitHub {
          owner = "chisui";
          repo = "zsh-nix-shell";
          rev = "v0.1.0";
          sha256 = "0snhch9hfy83d4amkyxx33izvkhbwmindy0zjjk28hih1a9l2jmx";
        };
      }];
      shellAliases = {
        "tb" = "nc termbin.com 9999";
        "vim" = "nvim";
        "ip" = "ip -c";
      };
      oh-my-zsh = {
        enable = true;
        plugins = [ "git" "sudo" ];
        theme = lib.mkDefault "fishy";
      };
    };
  };
}

