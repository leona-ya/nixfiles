{config, pkgs, ...}:

{
  l.sops.secrets = {
    "services/wireguard-endpoint/private_key" = {
      owner = "root";
      group = "root";
      mode = "0400";
    };
    "services/wireguard-endpoint/pre_shared_key" = {
      owner = "root";
      group = "root";
      mode = "0400";
    };
  };

  networking.wireguard.useNetworkd = true;
  networking.wireguard.interfaces."fc" = {
    type = "wireguard";
    ips = [
      "192.168.28.1/32"
      "2a01:4f9:3a:1448:c0ff:eef0:d:1/112"
    ];
    listenPort = 51855;
    privateKeyFile = config.sops.secrets."services/wireguard-endpoint/private_key".path;
    table = "auto";
    peers = [{
      name = "fc";
      endpoint = "78.94.116.221:51855";
      allowedIPs = [
        "2a01:4f9:3a:1448:c0ff:ee:f00d::/112"
      ];
      publicKey = "nF/0tjlkP4Aw2rRwP/6nixe2KXDSb2LAAxa/o2CNw0s=";
      presharedKeyFile = config.sops.secrets."services/wireguard-endpoint/pre_shared_key".path;
      persistentKeepalive = 10;
    }];
    allowedIPsAsRoutes = true;
  };

  systemd.services."wg-quick@fc.service" = {
    enable = true;
    upheldBy = [ "networking.target" ];
  };
}
