{ pkgs, ... }:
{
  virtualisation.libvirtd = {
    enable = true;
    package = pkgs.libvirt.override {
      enableXen = false;
    };
    allowedBridges = [
      "br-vms"
    ];
  };
  services.prometheus.exporters.node.extraFlags = [
    "--collector.netdev.device-include=^(eth0|br-vms)$"
  ];
}
