{
  pkgs,
  lib,
  config,
  ...
}:

{
  l.sops.secrets."all/users/root_pw".neededForUsers = true;

  users.users.root = {
    shell = pkgs.zsh;
    hashedPasswordFile = config.sops.secrets."all/users/root_pw".path;
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
