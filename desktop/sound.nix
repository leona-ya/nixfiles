{ pkgs, ... }:

{
  users.users.em0lar.packages = with pkgs; [ pavucontrol qjackctl ];

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
};
}
