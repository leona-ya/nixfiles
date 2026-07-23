{ config, pkgs, ... }:

{
  l.sops.secrets = {
    "services/wireguard-endpoint/private_key" = { };
    "services/wireguard-endpoint/pre_shared_key" = { };
  };

  networking.wireguard.useNetworkd = true;
  networking.wireguard.interfaces."fc" = {
    type = "wireguard";
    ips = [
      "192.168.28.2/32"
      "2a01:4f9:3a:1448:c0ff:eef0:d:1/112"
    ];
    listenPort = 51855;
    privateKeyFile = config.sops.secrets."services/wireguard-endpoint/private_key".path;
    peers = [
      {
        name = "fc";
        endpoint = "78.94.116.221:51855";
        allowedIPs = [
          "95.217.67.15/32"
          "2a01:4f9:3a:1448:c0ff:ee:f00d::/112"
        ];
        publicKey = "nF/0tjlkP4Aw2rRwP/6nixe2KXDSb2LAAxa/o2CNw0s=";
        presharedKeyFile = config.sops.secrets."services/wireguard-endpoint/pre_shared_key".path;
        persistentKeepalive = 10;
      }
    ];
    allowedIPsAsRoutes = true;
  };
  networking.wireguard.interfaces."wrk" = {
    type = "wireguard";
    ips = [
      "192.168.29.2/32"
      "2a01:4f9:3a:1448:c1ff::1/112"
    ];
    listenPort = 51856;
    privateKeyFile = config.sops.secrets."services/wireguard-endpoint/private_key".path;
    peers = [
      {
        name = "wrk";
        allowedIPs = [
          "95.217.67.14/32"
          "2a01:4f9:3a:1448:c1ff::/112"
        ];
        publicKey = "L38ewiF/mp7bD3wTVw0wCNmH/A4S/pIFMZh3paYZ2iE=";
        presharedKeyFile = config.sops.secrets."services/wireguard-endpoint/pre_shared_key".path;
        persistentKeepalive = 10;
      }
    ];
    allowedIPsAsRoutes = true;
  };
  networking.firewall.allowedUDPPorts = [ 51856 ];
}
