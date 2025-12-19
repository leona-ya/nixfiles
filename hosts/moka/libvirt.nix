{ ... }: {
  virtualisation.libvirtd = {
    enable = true;
    allowedBridges = [
      "br-vms"
    ];
  };
  services.prometheus.exporters.node.extraFlags = [
    "--collector.netdev.device-include=^(eth0|br-vms)$"
  ];
}
