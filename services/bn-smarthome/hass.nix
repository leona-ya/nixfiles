{
  config,
  lib,
  pkgs,
  ...
}:
{
  l.sops.secrets."services/bn-smarthome/hass-mqtt-yaml.nix".owner = "hass";
  services.home-assistant = {
    enable = true;
    configWritable = false;
    extraComponents = [
      "automation"
      "default_config"
      "met"
      "esphome"
      "counter"
      "energy"
      "hardware"
      "history"
      "image"
      "calendar"
      "input_boolean"
      "input_button"
      "input_datetime"
      "input_number"
      "input_select"
      "input_text"
      "logbook"
      "network"
      "schedule"
      "script"
      "ssdp"
      "sun"
      "system_health"
      "tag"
      "timer"
      "usb"
      "zeroconf"
      "zone"
      "frontend"
      "hue"
      "sonos"
      "unifi"
      "tasmota"
    ];
    config = {
      homeassistant = {
        name = "leona's HASS";
        unit_system = "metric";
        currency = "EUR";
        time_zone = "Europe/Berlin";
        external_url = "https://hass.bn.leona.is";
        internal_url = "https://hass.bn.leona.is";
        #        latitude = "!secret home_lat";
        #        longitude = "!secret home_lon";
        elevation = 70;
      };
      http = {
        use_x_forwarded_for = true;
        trusted_proxies = [
          "::1"
          "127.0.0.1"
        ];
      };
      automation = "!include automations.yaml";
      scene = "!include scenes.yaml";
      mqtt = "!include mqtt.yaml";
      logger = {
        default = "info";
      };
      default_config = { };
    };
  };
  systemd.services.home-assistant.preStart = ''
    ${pkgs.nix}/bin/nix eval --raw -f ${
      config.sops.secrets."services/bn-smarthome/hass-mqtt-yaml.nix".path
    } yaml > /var/lib/hass/mqtt.yaml
  '';
  services.nginx.virtualHosts."hass.bn.leona.is" = {
    forceSSL = true;
    enableACME = true;
    extraConfig = ''
      proxy_buffering off;
    '';
    locations."/" = {
      proxyPass = "http://[::1]:8123";
      proxyWebsockets = true;
    };
  };
}
