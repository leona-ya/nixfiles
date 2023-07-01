{ ... }: {
  networking.nftables.ruleset = let
    mtuFix = ''
      meta nfproto ipv6 tcp flags syn tcp option maxseg size 1305-65535 tcp option maxseg size set 1304
      meta nfproto ipv4 tcp flags syn tcp option maxseg size 1325-65535 tcp option maxseg size set 1324
    '';
  in ''
    table inet mtu-fix {
      chain input {
        type filter hook input priority filter; policy accept;
        ${mtuFix}
      }
      chain output {
        type filter hook output priority filter; policy accept;
        ${mtuFix}
      }
      chain forward {
        type filter hook forward priority filter; policy accept;
        ${mtuFix}
      }
    }
  '';
  services.firewall.extraForwardRules = ''
    ct state invalid drop
    ct state established,related accept

    iifname br-lan oifname ppp-wan ct state new accept

    iifname br-lan oifname wg-server ct state new accept
    iifname wg-server oifname br-lan ct state new accept
  '';
  networking.nat = {
    internalInterfces = [ "br-lan" ];
    externalInterface = "ppp-wan";
  };
  networking.firewall.interfaces = {
    "br-lan" = {
      allowedUDPPorts = [53];
      allowedTCPPorts = [53];
    };
  };
}
