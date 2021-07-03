{ ... }: {
  em0lar.bind = {
    enable = true;
    zones = [
      {
        name = "lan.int.sig.de.em0lar.dev";
        master = true;
        file = "/var/lib/named/zones/lan.int.sig.de.em0lar.dev.zone";
        extraConfig = ''
          allow-update { localhost; };
        '';
      }
    ];
    enableAllowQueryOption = false;
  };
  services.bind = {
    cacheNetworks = [
      "any"
    ];
  };
}
