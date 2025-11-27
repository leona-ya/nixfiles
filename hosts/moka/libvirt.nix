{ ... }: {
  virtualisation.libvirtd = {
    enable = true;
    allowedBridges = [
      "br-vms"
    ];
  };
}
