{ config, lib, ... }:

let
  hosthelper = import ../../hosts { inherit lib config; };
in {
  imports = [
    ./prometheus.nix
    ./grafana.nix
    ./alertmanager.nix
    ./alertmanager-bot.nix
  ];

  l.telegraf.extraInputs = {
    http_response = {
      interval = "90s";
      urls = [
        "https://matrix.labcode.de/health"
        "https://labcode.de/.well-known/matrix/server"
        "https://leona.is"
        "https://cloud.leona.is/login"
        "https://altenforst.de"
      ];
    };
    ping = [
      {
        urls = hosthelper.groups.g_public_v6_hostnames;
        ipv6 = true;
        method = "native";
      }
      {
        urls = hosthelper.groups.g_public_v4_hostnames;
        arguments = ["-4"];
        method = "native";
      }
    ];
  };
}
