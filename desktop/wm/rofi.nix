{ pkgs, ... }:

{
  home-manager.users.em0lar = {
    programs.rofi = {
      enable = true;
      theme = "solarized";
      pass.enable = true;
    };
  };
}
