{ ... }:
let
  wanInterface = "ppp-wan";
in {
  l.nftables = {
    extraForward = ''
      ct state invalid drop
      ct state established,related accept

      iifname br-lan oifname ${wanInterface} ct state new accept
      iifname br-tethys oifname ${wanInterface} ct state new accept
      iifname br-dmz oifname ${wanInterface} ct state new accept

      iifname br-lan oifname br-tethys ct state new accept
      iifname br-tethys oifname br-lan ct state new accept

      iifname br-lan oifname wg-server ct state new accept
      iifname wg-server oifname br-lan ct state new accept
      iifname br-tethys oifname wg-server ct state new accept
      iifname wg-server oifname br-tethys ct state new accept

      iifname br-lan oifname br-dmz ct state new accept
      iifname br-tethys oifname br-tethys ct state new accept
    '';
    extraConfig = ''
      table ip nat {
      	chain prerouting {
      		type nat hook prerouting priority 0; policy accept;
      	}

      	chain postrouting {
      		type nat hook postrouting priority 100; policy accept;
      		oifname ${wanInterface} masquerade
      	}
      }
    '';
  };
  networking.firewall.interfaces = {
    "br-lan" = {
      allowedUDPPorts = [53];
      allowedTCPPorts = [53];
    };
    "br-tethys" = {
      allowedUDPPorts = [53];
      allowedTCPPorts = [53];
    };
    "br-dmz" = {
      allowedUDPPorts = [53];
      allowedTCPPorts = [53];
    };
  };
}
