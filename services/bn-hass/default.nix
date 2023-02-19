{ lib, ... }: {
  services.home-assistant = {
    enable = true;
    configWritable = false;
    config = lib.listToAttrs (map (x: lib.nameValuePair x {}) [
      "automation" "config" "counter" "energy" "hardware" "history" "image"
      "input_boolean" "input_button" "input_datetime" "input_number" "input_select" "input_text"
      "logbook" "network" "schedule" "script" "ssdp" "sun" "system_health" "tag"
      "timer" "usb" "zerconf" "zone"  "frontend"
      "hue" "sonos" "unifi"
    ]) // {
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
        trusted_proxies = [ "::1" "127.0.0.1" ];
      };
      automation = "!include automations.yaml";
      scene = "!include scenes.yaml";
      logger = {
        default = "info";
      };
    };
  };
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
