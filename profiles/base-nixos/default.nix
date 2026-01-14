{
  config,
  lib,
  pkgs,
  inputs,
  options,
  ...
}:
{
  imports = [
    ./acme.nix
    ./nginx.nix
    inputs.home-manager.nixosModules.home-manager
    inputs.sops-nix.nixosModules.sops
    ../../users/root
    ../../modules
  ];
  deployment.tags = [
    pkgs.stdenv.hostPlatform.system
    config.networking.domain
  ];
  deployment.targetUser = lib.mkDefault "leona";
  deployment.targetHost = lib.mkDefault config.networking.fqdn;

  documentation.nixos.enable = false;
  hardware.enableRedistributableFirmware = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  time.timeZone = "Etc/UTC";
  users.mutableUsers = false;
  hardware.enableAllFirmware = true;

  security.sudo.enable = false;
  security.sudo-rs.enable = true;
  security.sudo-rs.wheelNeedsPassword = lib.mkDefault false;

  networking.useNetworkd = true;
  networking.nftables.enable = true;
  networking.firewall.filterForward = true;
  networking.useDHCP = false;
  services.resolved = lib.mkMerge [
    {
      dnssec = "false"; # broken :(
    }
    (lib.optionalAttrs (options.services.resolved ? settings) {
      settings.Resolve = {
        FallbackDNS = "";
        Cache = "no-negative";
      };
    })
    (lib.optionalAttrs
      (options.services.resolved ? extraConfig && (options.services.resolved.extraConfig.visible or true))
      {
        extraConfig = ''
          FallbackDNS=
          Cache=no-negative
        '';
      }
    )
  ];
  services.journald.extraConfig = "SystemMaxUse=256M";

  services.openssh = {
    enable = true;
    ports = [ 22 ];
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = lib.mkDefault "no";
    };
  };
  programs.mosh.enable = true;

  environment.systemPackages = with pkgs; [
    config.boot.kernelPackages.cpupower
    lm_sensors
    wireguard-tools
  ];
}
