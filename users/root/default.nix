{
  pkgs,
  lib,
  config,
  ...
}:

{
  l.sops.secrets."all/users/root_pw" = {
    enable = !config.l.meta.bootstrap;
    neededForUsers = true;
  };

  users.users.root = {
    shell = pkgs.zsh;
  }
  // lib.optionalAttrs (!config.l.meta.bootstrap) {
    hashedPasswordFile = lib.mkOverride 500 config.sops.secrets."all/users/root_pw".path;
  };

  home-manager.users.root = {
    home.stateVersion = "22.05";
    # prevent ifd
    manual.manpages.enable = false;

    programs.ssh = {
      enable = true;
      matchBlocks =
        let
          leona = {
            port = 54973;
          };
        in
        {
          "*.net.leona.is" = leona;
          "*.lan" = leona;
        };
    };

    programs.zsh =
      let
        uCfg = config.home-manager.users.leona.programs.zsh;
      in
      {
        inherit (uCfg)
          enable
          shellAliases
          oh-my-zsh
          autosuggestion
          ;
      };
    programs.starship = config.home-manager.users.leona.programs.starship;
  };
}
