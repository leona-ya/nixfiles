{ pkgs, lib, config, ... }:

{
  l.sops.secrets."all/users/root_pw".neededForUsers = true;

  users.users.root = {
    shell = pkgs.zsh;
    passwordFile = config.sops.secrets."all/users/root_pw".path;
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
        "watch" = "watch -c";
        "xtssh" = "TERM=xterm-256color ssh";
        "use" = "nix-shell -p ";
        "cat" = "bat --style=header ";
        "grep" = "rg";
        "l" = "exa";
        "ls" = "exa";
        "ll" = "exa -l";
        "la" = "exa -la --git";
        "tree" = "exa -T";
        "sudo" = "sudo ";
        "wget" = "wget2";
        "wt" = "wget2";
      };
      enableAutosuggestions = true;
      initExtra = builtins.readFile ../zsh-extra.zsh;
      oh-my-zsh = {
        enable = true;
        plugins = [
          "gitfast"
          "git"
          "sudo"
          "virtualenvwrapper"
          "zsh-autocomplete"
        ];
        theme = lib.mkDefault "powerlevel10k/powerlevel10k";
        custom = builtins.toString (pkgs.stdenv.mkDerivation {
          name = "oh-my-zsh-custom-dir";
          buildInputs = with pkgs; [
            zsh-autocomplete
            zsh-powerlevel10k
          ];
          unpackPhase = "true";
          installPhase =
            ''
              mkdir -p $out/themes
              ln -s ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k $out/themes/powerlevel10k
              mkdir -p $out/plugins
              ln -s ${pkgs.zsh-autocomplete}/share/zsh-autocomplete $out/plugins/zsh-autocomplete
            '';
        });
      };
    };
  };
}

