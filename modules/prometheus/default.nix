# inspired by petabyteboy (git.petabyte.dev/petabyteboy/nixfiles)
{ config, lib, ... }:

let
  cfg = config.em0lar.prometheus;

  inherit (lib) mkEnableOption mkIf mkOption types mapAttrs' filterAttrs nameValuePair attrNames;
in {
  options.em0lar.prometheus = {
    enable = mkEnableOption "em0lar prometheus";

    host = mkOption {
      type = types.str;
    };
    exporters = mkOption {
      type = with types; listOf str;
      default = [];
    };
  };
  config = mkIf cfg.enable {
    em0lar.prometheus.exporters = map (
      name: name + "-exporter"
    ) (
      attrNames (
        filterAttrs (
          name: exporter: exporter.enable
        ) config.services.prometheus.exporters
      )
    );

    services.prometheus.exporters.node.enable = true;
    services.prometheus.exporters.node.enabledCollectors = [ "systemd" ];
    services.prometheus.exporters.nginx.enable = true;
    services.nginx.statusPage = true;
    services.nginx.virtualHosts.${cfg.host} = {
      locations = mapAttrs' (
        name: exporter: nameValuePair "/${name}-exporter/metrics" {
          proxyPass = "http://127.0.0.1:${toString exporter.port}/metrics";
          extraConfig = ''
            allow fd8f:d15b:9f40::/48;
            allow ::/8;
            deny all;
          '';
        }
      ) (
        filterAttrs (
          name: exporter: exporter ? enable && exporter.enable
        ) config.services.prometheus.exporters
      );
    };
  };
}
