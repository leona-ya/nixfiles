{ pkgs, ... }: {
  home-manager.users.leona.programs.neovim = {
    enable = true;
    vimAlias = true;
    plugins = with pkgs.vimPlugins; [
      { plugin = ultisnips;
        config = ''
          let g:UltiSnipsExpandTrigger       = '<tab>'
          let g:UltiSnipsJumpForwardTrigger  = '<tab>'
          let g:UltiSnipsJumpBackwardTrigger = '<s-tab>'
        '';
      }
      { plugin = supertab;
        config = ''
          let g:SuperTabDefaultCompletionType = '<C-n>'
        '';
      }
      { plugin = YouCompleteMe;
        config = ''
          let g:ycm_key_list_select_completion = ['<C-n>', '<Down>']
          let g:ycm_key_list_previous_completion = ['<C-p>', '<Up>']
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
    ];
    extraConfig = ''
      set expandtab
      set shiftwidth=2
      set number
    '';
  };
}
