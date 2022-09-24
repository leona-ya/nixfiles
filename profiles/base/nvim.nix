{ pkgs, ... }: {
  home-manager.users.leona.programs.neovim = {
    enable = true;
    vimAlias = true;
    plugins = with pkgs.vimPlugins; [
      { plugin = ultisnips;
        config = ''
            let g:UltiSnipsExpandTrigger       = '<Tab>'
            let g:UltiSnipsJumpForwardTrigger  = '<Tab>'
            let g:UltiSnipsJumpBackwardTrigger = '<S-Tab>'
        '';
      }
      { plugin = ctrlp-vim; }
      { plugin = vimtex;
        config = ''
          let g:vimtex_compiler_latexmk_engines = {
            \ '_' : '-lualatex',
            \ 'pdflatex'         : '-pdf',
            \ 'luatex'           : '-lualatex',
            \ 'lualatex'         : '-lualatex',
            \ 'xelatex'          : '-xelatex',
          \}
	      '';
      }
      { plugin = YouCompleteMe; }
    ];
    extraConfig = ''
      set relativenumber
    '';
  };
}
