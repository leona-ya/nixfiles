{ ... }: {
  em0lar.bind = {
    enable = true;
    zones = [
      {
        name = "lan";
        master = true;
        file = "/var/lib/named/zones/lan.zone";
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
