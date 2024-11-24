{ ... }: {
  home-manager.users.leona = {
    services.darkman = {
      enable = true;
      settings = {
        lat = 50.5;
        lng = 8.0;
      };
    };
    systemd.user.services.darkman = {
      Unit = {
        After = [ "sway-session.target" ];
      };
    };
  };
}
