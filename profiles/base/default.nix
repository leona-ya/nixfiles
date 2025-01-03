{ inputs, pkgs, lib, config, ... }:

{
  imports = [
    ../../modules
    inputs.home-manager.nixosModules.home-manager
    inputs.sops-nix.nixosModules.sops
    ../../users/root
    ../../users/leona
    ./nginx.nix
    ./helix.nix
    ./acme.nix
    ./bat.nix
  ];

  nixpkgs.overlays = lib.attrValues inputs.self.overlays;
  nix.registry.nixpkgs.flake = inputs.nixpkgs;

  nixpkgs.config.permittedInsecurePackages = [
    "olm-3.2.16"
  ];
  deployment.tags = [ pkgs.stdenv.hostPlatform.system config.networking.domain ];
  deployment.targetUser = lib.mkDefault "leona";
  deployment.targetHost = lib.mkDefault config.networking.fqdn;
  deployment.targetPort = lib.mkDefault (lib.head config.services.openssh.ports);

  system.switch.enableNg = true;
  hardware.enableRedistributableFirmware = true;
  boot.kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;
  security.pki.certificateFiles = [ ../../lib/leona-is-ca.crt ];
  users.mutableUsers = false;
  home-manager.useUserPackages = true;
  home-manager.useGlobalPkgs = true;
  nixpkgs.config.allowUnfree = true;
  hardware.enableAllFirmware = true;
  nix = {
    package = pkgs.lix;
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      builders-use-substitutes = true;
      trusted-users = [ "root" "@wheel" "leona" ];
    };
    gc = {
      automatic = lib.mkDefault true;
      options = lib.mkDefault "--delete-older-than 7d";
    };
  };

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
  services.iperf3.enable = true;
  services.iperf3.openFirewall = true;

  security.sudo.enable = false;
  security.sudo-rs.enable = true;
  security.sudo-rs.wheelNeedsPassword = lib.mkDefault false;

  time.timeZone = "Etc/UTC";

  environment.variables.EDITOR = "hx";
  programs.zsh.enable = true;

  networking.useNetworkd = true;
  networking.nftables.enable = true;
  networking.useDHCP = false;
  services.resolved.dnssec = "false"; # broken :(
  services.resolved.extraConfig = ''
    FallbackDNS=
    Cache=no-negative
  '';

  environment.systemPackages = with pkgs; [
    bat
    bottom
    bind.dnsutils # for dig
    config.boot.kernelPackages.cpupower
    difftastic
    fd
    file
    eza
    git
    gnupg
    gptfdisk
    htop
    iperf
    jq
    lm_sensors
    mtr
    nmap
    openssl
    ripgrep
    rsync
    sshfs
    tcpdump
    tmux
    #wget
    whois
    wireguard-tools
  ];
}
