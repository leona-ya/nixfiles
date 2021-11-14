{ config, ... }: {
  em0lar.sops.secrets = {
    "hosts/haku/openvpn/client_ca" = {};
    "hosts/haku/openvpn/client_cert" = {};
    "hosts/haku/openvpn/client_key" = {};
    "hosts/haku/openvpn/dh" = {};
  };
  services.openvpn.servers.client = {
    config = ''
      dev tun0
      port 993
      proto tcp-server
      cipher AES-256-GCM
      server 10.151.8.0 255.255.255.128
      ca ${config.sops.secrets."hosts/haku/openvpn/client_ca".path}
      cert ${config.sops.secrets."hosts/haku/openvpn/client_cert".path}
      key ${config.sops.secrets."hosts/haku/openvpn/client_key".path}
      dh ${config.sops.secrets."hosts/haku/openvpn/dh".path}
    '';
    up = "ip route add 10.151.8.0/25 dev tun0";
    down = "ip route del 10.151.8.0/25 dev tun0";
  };
  em0lar.nftables = {
    extraForward = ''
      ct state invalid drop
      ct state established,related accept

      iifname tun0 oifname eth0 ct state new accept
      iifname tun0 oifname wg-public ct state new accept
      iifname tun0 oifname wg-server ct state new accept
      iifname tun0 oifname wg-clients ct state new accept

      iifname wg-server oifname tun0 ct state new accept
      iifname wg-clients oifname tun0 ct state new accept
    '';
    extraConfig = ''
      table ip nat {
        chain prerouting {
          type nat hook prerouting priority 0; policy accept;
        }

        chain postrouting {
          type nat hook postrouting priority 100; policy accept;
          iifname tun0 oifname eth0 masquerade
        }
      }
    '';
  };
  networking.firewall.interfaces."eth0".allowedTCPPorts = [993];
}
