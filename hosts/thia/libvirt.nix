{ ... }: {
  virtualisation.libvirtd.enable = true;
  systemd.network = {
    netdevs."05-br-vms" = {
      netdevConfig = {
        Name = "br-vms";
        Kind = "bridge";
      };
    };
    networks."05-br-vms" = {
      matchConfig = {
        Name = "br-vms";
      };
      address = [
        "100.64.0.0/24"
      ];
      networkConfig.ConfigureWithoutCarrier = true;
    };
  };

  networking.firewall = {
    extraForwardRules = ''
      ct state invalid drop
      ct state established,related accept

      iifname br-vms oifname eth0 ct state new accept
    '';
  };
  networking.nat = {
    enable = true;
    internalInterfaces = [ "br-vms" ];
    externalInterface = "eth0";
  };
  boot.kernel.sysctl."net.ipv6.conf.all.forwarding" = true;
  boot.kernel.sysctl."net.ipv4.conf.all.forwarding" = true;
}
