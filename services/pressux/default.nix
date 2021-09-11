{ pkgs, config, ... }:
let
  format = pkgs.formats.json {};
  configFile = format.generate "config.jsonq" {
    server = "mail.em0lar.dev";
    username = "print@em0lar.dev";
    password_file = config.em0lar.secrets."pressux_password_file".path;
  };
in {
  em0lar.secrets."pressux_password_file".owner = "pressux";
  systemd.services.pressux = {
    description = "pressux";
    after = [ "network.target" "cups.service" ];
    wantedBy = [ "multi-user.target" ];
    path = [ pkgs.cups ];

    serviceConfig = {
      Type = "simple";
      User = "pressux";
      Group = "pressux";
      ExecStart = "${pkgs.pressux}/bin/pressux --config-file ${configFile}";
      Restart = "always";
    };
  };

  users = {
    users.pressux = {
      group = "pressux";
      isSystemUser = true;
    };
    groups.pressux = {};
  };
}
