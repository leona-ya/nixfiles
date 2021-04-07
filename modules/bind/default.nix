{ pkgs, lib, config, ... }:
let
  cfg = config.em0lar.bind;

in {
  options.em0lar.bind = with lib; {
    enable = mkEnableOption "em0lar bind";
    localForwarding = mkOption {
      type = types.bool;
      default = true;
    };
    zones = mkOption {
      type = types.listOf types.attrs;
      default = [];
    };
    extraOptions = mkOption {
      type = types.str;
      default = "";
    };
    extraConfig = mkOption {
      type = types.str;
      default = "";
    };
  };
  config = lib.mkIf cfg.enable {
    services.resolved.enable = false;
    services.bind = {
      enable = true;
      zones = [
        {
          name = "localhost";
          master = true;
          file = ./rfc1912_zones/localhost.zone;
        }
        {
          name = "127.in-addr.arpa";
          master = true;
          file = ./rfc1912_zones/127.in-addr.arpa.zone;
        }
        {
          name = "0.in-addr.arpa";
          master = true;
          file = ./rfc1912_zones/0.in-addr.arpa.zone;
        }
        {
          name = "255.in-addr.arpa";
          master = true;
          file = ./rfc1912_zones/255.in-addr.arpa.zone;
        }
      ] ++ cfg.zones;
      forwarders = [
          "2606:4700:4700::1111"
          "2606:4700:4700::1001"
          "2001:4860:4860::8888"
          "2001:4860:4860::8844"
          "1.1.1.1"
          "1.0.0.1"
          "8.8.8.8"
          "8.8.4.4"
      ];
      cacheNetworks = [
        "127.0.0.0/24"
        "::1/128"
      ];
      extraOptions = ''
        querylog no;
      '' + cfg.extraOptions;
      extraConfig = ''
        statistics-channels {
          inet 127.0.0.1 port 8053;
        };
      '' + cfg.extraConfig;
    };
    services.prometheus.exporters.bind = {
      enable = true;
      bindVersion = "xml.v3";
    };
    em0lar.telegraf.extraInputs = lib.mkIf config.em0lar.telegraf.enable {
      prometheus =  {
        urls = [ "http://127.0.0.1:9119" ];
      };
    };
  };
}
