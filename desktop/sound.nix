{ pkgs, ... }:

{
  users.users.em0lar.packages = with pkgs; [ pavucontrol ];

  sound.enable = true;
  nixpkgs.config.pulseaudio = true;
  hardware.pulseaudio = {
    enable = true;
    package = pkgs.pulseaudioFull;
  };
}
