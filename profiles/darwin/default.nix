{ inputs, pkgs, ... }: {
  imports = [
    inputs.home-manager.darwinModules.home-manager
    ./home-manager-fixes.nix
  ];
  security.pam.services.sudo_local.touchIdAuth = true;
  
  system.activationScripts.setting.text = ''
    # Allow opening apps from any source
    sudo spctl --master-disable
  '';
  nix.settings.sandbox = "relaxed";

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
    programs.gpg = {
      enable = true;
      scdaemonSettings = {
        disable-ccid = true;
      };
    };
    home.file.".gnupg/gpg-agent.conf".text = ''
      enable-ssh-support
    '';
    # dev envs
    home.file = {
      ".envs/openjdk17".source = "${pkgs.jdk17}";
      ".envs/openjdk21".source = "${pkgs.jdk21}";
      ".envs/python311".source = "${pkgs.python311}";
      ".envs/python312".source = "${pkgs.python312}";
    };
    fonts.fontconfig.enable = true;
    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
      config.global.load_dotenv = false;
    };
    programs.zsh = {
      initContent = ''
        eval "$(${pkgs.zoxide}/bin/zoxide init zsh)"
        eval "$(direnv hook zsh)"
      '';
    };
    home.packages = with pkgs; [
      element-desktop
      maven
      nodejs
      pre-commit
      ruff
      uv
      yarn
      zoxide
      # nixpkgs tools
      nixfmt-rfc-style
      nix-output-monitor
      nix-init
      nurl
      nix-update
      nix-tree
      nixpkgs-review
    ];
  };
}
