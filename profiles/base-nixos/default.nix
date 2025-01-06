{ config, lib, pkgs, inputs, ... }: {
  imports = [
    ./acme.nix
    ./nginx.nix
    inputs.home-manager.nixosModules.home-manager
    inputs.sops-nix.nixosModules.sops
    ../../users/root
    ../../modules
  ];
  deployment.tags = [ pkgs.stdenv.hostPlatform.system config.networking.domain ];
  deployment.targetUser = lib.mkDefault "leona";
  deployment.targetHost = lib.mkDefault config.networking.fqdn;
  deployment.targetPort = lib.mkDefault (lib.head config.services.openssh.ports);
  hardware.enableRedistributableFirmware = true;
  boot.kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;

  time.timeZone = "Etc/UTC";
  users.mutableUsers = false;
  hardware.enableAllFirmware = true;

  system.switch.enableNg = true;
  security.sudo.enable = false;
  security.sudo-rs.enable = true;
  security.sudo-rs.wheelNeedsPassword = lib.mkDefault false;

  networking.useNetworkd = true;
  networking.nftables.enable = true;
  networking.useDHCP = false;
  services.resolved.dnssec = "false"; # broken :(
  services.resolved.extraConfig = ''
    FallbackDNS=
    Cache=no-negative
  '';
  services.journald.extraConfig = "SystemMaxUse=256M";

  services.openssh = {
    enable = true;
    ports = [ 54973 ];
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = lib.mkDefault "no";
    };
  };
  programs.mosh.enable = true;

  l.sops.secrets."all/users/leona_pw".neededForUsers = true;
  users.users.leona.hashedPasswordFile = lib.mkDefault config.sops.secrets."all/users/leona_pw".path;

  environment.systemPackages = with pkgs; [
    config.boot.kernelPackages.cpupower
    lm_sensors
    wireguard-tools
  ];
}
