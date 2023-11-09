{ pkgs, ... }:

{
  home-manager.users.leona = {
    programs.wofi = {
      enable = true;
#      theme = "solarized";
    };
  };
}
