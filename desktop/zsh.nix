{ pkgs, lib, ... }:

{
  environment.variables.PURE_GIT_PULL = "0";
  home-manager.users.em0lar = {
    programs.zsh = {
      initExtra = ''
        fpath+=("${pkgs.pure-prompt}/share/zsh/site-functions")
        if [ "$TERM" != dumb ]; then
          autoload -U promptinit && promptinit && prompt pure
        fi
      '';
      oh-my-zsh.theme = lib.mkForce "";
      oh-my-zsh.extraConfig = ''
        ZSH_THEME=""
      '';
    };
  };
  home-manager.users.root = {
    programs.zsh = {
      enable = true;
      initExtra = ''
        fpath+=("${pkgs.pure-prompt}/share/zsh/site-functions")
        if [ "$TERM" != dumb ]; then
          autoload -U promptinit && promptinit && prompt pure
        fi
      '';
      oh-my-zsh.theme = lib.mkForce "";
      oh-my-zsh.extraConfig = ''
        ZSH_THEME=""
      '';
    };
  };
}
