{ config, ... }:

{
  networking.useDHCP = false;
  networking.hostName = "mimas";
  networking.domain = "int.sig.de.em0lar.dev";
  services.resolved.domains = [
    "int.sig.de.labcode.de"
  ];

  networking.wireless.enable = true;
  networking.interfaces.wlp61s0.useDHCP = true;
  networking.interfaces.enp0s31f6.useDHCP = true;
  em0lar.secrets = {
    "wpa_supplicant.conf".source-path = "${../../secrets/mimas/wpa_supplicant.conf.gpg}";
  };
  environment.etc."wpa_supplicant.conf".source = config.em0lar.secrets."wpa_supplicant.conf".path;
}
