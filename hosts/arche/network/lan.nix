{ ... }: {
  systemd.network = {
    # BRIDGES
    netdevs."10-br-clients" = {
      netdevConfig = {
        Name = "br-clients";
        Kind = "bridge";
      };
    };
    networks."20-br-clients" = {
      matchConfig.Name = "br-clients";
      address = [
        "10.20.0.1/23"
        "fd14:65c0:ffee::1/63"
        "2001:4090:e013:2d00::1/63" # someone got the :: ???
      ];
      networkConfig = {
        ConfigureWithoutCarrier = true;
        IPv6AcceptRA = false;
        IPv6PrivacyExtensions = false;
      };
    };
    netdevs."10-br-infra" = {
      netdevConfig = {
        Name = "br-infra";
        Kind = "bridge";
      };
    };
    networks."20-br-infra" = {
      matchConfig.Name = "br-infra";
      address = [
        "10.20.10.1/23"
        "fd14:65c0:ffee:10::1/63"
        "2001:4090:e013:2d10::1/63"
      ];
      networkConfig = {
        ConfigureWithoutCarrier = true;
        IPv6AcceptRA = false;
        IPv6PrivacyExtensions = false;
      };
    };
    netdevs."10-br-iot" = {
      netdevConfig = {
        Name = "br-iot";
        Kind = "bridge";
      };
    };
    networks."20-br-iot" = {
      matchConfig.Name = "br-iot";
      address = [
        "10.20.20.1/23"
        "fd14:65c0:ffee:20::1/63"
        "2001:4090:e013:2d20::1/63"
      ];
      networkConfig = {
        ConfigureWithoutCarrier = true;
        IPv6AcceptRA = false;
        IPv6PrivacyExtensions = false;
      };
    };
    # PHYSICAL
    networks."10-eth-rcy" = {
      matchConfig = {
        Name = "eth-rcy";
      };
      networkConfig = {
        Bridge = "br-clients";
      };
    };
  };
}
