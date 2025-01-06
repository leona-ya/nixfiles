{ inputs, pkgs, ... }: {
  imports = [
    inputs.home-manager.darwinModule
    ./home-manager-fixes.nix
  ];
  security.pam.enableSudoTouchIdAuth = true;
  
  system.activationScripts.setting.text = ''
    # Allow opening apps from any source
    sudo spctl --master-disable
  '';

  # TODO: deduplicate
  nixpkgs.config.allowUnfree = true;
  fonts.packages = with pkgs; [
    noto-fonts-emoji
    dejavu_fonts
    fira
    fira-mono
    unifont
    roboto
    jetbrains-mono
    font-awesome
    meslo-lgs-nf
    inter
    questrial-regular
    monaspace
    annieuseyourtelescope
  ];
  home-manager.users.leona = {
  fonts.fontconfig.enable = true;
    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
      config.global.load_dotenv = false;
    };
    programs.zsh = {
      initExtra = ''
        eval "$(${pkgs.zoxide}/bin/zoxide init zsh)"
        eval "$(direnv hook zsh)"
      '';
    };
    home.packages = with pkgs; [
      element-desktop
      pre-commit
      zoxide
      # nixpkgs tools
      nix-output-monitor
      nix-init
      nurl
      nix-update
      nix-tree
      nixpkgs-review
    ];
  };
}
