{ config, lib, pkgs, hosts, ... }:

{
  services.prometheus = {
    enable = true;
    globalConfig.scrape_interval = "60s";
    webExternalUrl = "https://prometheus.em0lar.dev/";

    scrapeConfigs = [
      {
        job_name = "telegraf";
        metrics_path = "/metrics";
        static_configs = [
          {
            targets = [
              "[fd8f:d15b:9f40:102:5c52:b6ff:fee2:db4d]" # beryl
              "[fd8f:d15b:9f40:102:945b:9eff:fe23:2caa]" # foros
              "[fd8f:d15b:9f40:102:3016:54ff:fe12:f68c]" # ladon
              "[fd8f:d15b:9f40:0c20::1]" # naiad
              "[fd8f:d15b:9f40:0c21::1]" # myron
            ];
          }
        ];
      }
    ];
  };
}
