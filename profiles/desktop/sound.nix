{ pkgs, ... }:

{
  users.users.leona.packages = with pkgs; [
    pwvucontrol
    qjackctl
  ];

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    raopOpenFirewall = true;
    extraConfig = {
      pipewire-pulse = {
        network-discover = {
          "context.exec" = [
            {
              path = "pactl";
              args = "load-module module-native-protocol-tcp";
            }
          ];
        };
      };
      pipewire = {
        raop-discover = {
          "context.modules" = [
            {
              name = "libpipewire-module-raop-discover";
              args = { };
            }
          ];
        };
      };
    };
  };
}
