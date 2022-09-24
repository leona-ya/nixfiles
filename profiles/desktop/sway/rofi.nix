{ pkgs, ... }:

{
  home-manager.users.leona = {
    programs.rofi = {
      enable = true;
      theme = "solarized";
      pass.enable = true;
    };
  };
}
