{ ... }:

{
  home-manager.users.em0lar = {
    services.gammastep = {
      enable = true;
      latitude = "50.8";
      longitude = "7.2";
      temperature.day = 6500;
      temperature.night = 3500;
      settings.general.adjustment-method = "wayland";
    };
  };
}
