{ pkgs, config, ... }: {
  l.sops.secrets."services/ical-merger/config_yaml".owner = "ical-merger";

  systemd.services.ical-merger = {
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    restartTriggers = [ config.sops.secrets."services/ical-merger/config_yaml".path ];

    preStart = ''
      ln -fs ${config.sops.secrets."services/ical-merger/config_yaml".path} /var/lib/ical-merger/config.yaml
    '';

    serviceConfig = {
      Type = "simple";
      DynamicUser = false;
      User = "ical-merger";
      StateDirectory = "ical-merger";
      WorkingDirectory = "/var/lib/ical-merger";
      ExecStart = "${pkgs.ical-merger}/bin/ical-merger";
      Restart = "always";
    };

  };
  users.users.ical-merger = {
    description = "ical merger service";
    createHome = false;
    group = "ical-merger";
    isSystemUser = true;
  };
  users.groups.ical-merger = {};
  services.nginx.virtualHosts."cal.cloud.leona.is" = {
    enableACME = true;
    forceSSL = true;
    kTLS = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:8000";
    };
  };
}
