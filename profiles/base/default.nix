{ pkgs, lib, config, ... }:

{
  imports = [
    ../../users/root
    ../../users/leona
    ./nginx.nix
    ./helix.nix
  ];
  boot.kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;
  security.pki.certificateFiles = [ ../../lib/leona-is-ca.crt ];
  users.mutableUsers = false;
  home-manager.useUserPackages = true;
  home-manager.useGlobalPkgs = true;
  nixpkgs.config.allowUnfree = true;
  hardware.enableAllFirmware = true;
  nix = {
    extraOptions = ''
      experimental-features = nix-command flakes
      builders-use-substitutes = true
    '';
    settings.trusted-users = [ "root" "@wheel" "leona" ];
    gc = {
      automatic = lib.mkDefault true;
      options = lib.mkDefault "--delete-older-than 7d";
    };
  };

  services.journald.extraConfig = "SystemMaxUse=256M";

  services.openssh = {
    enable = true;
    ports = [ 54973 ];
    passwordAuthentication = false;
    kbdInteractiveAuthentication = false;
    permitRootLogin = lib.mkDefault "no";
  };
  programs.mosh.enable = true;
  services.iperf3.enable = true;
  services.iperf3.openFirewall = true;

  security.sudo.wheelNeedsPassword = lib.mkDefault false;

  time.timeZone = "Etc/UTC";

  environment.variables.EDITOR = "hx";
  programs.zsh.enable = true;

  networking.useNetworkd = true;
  l.nftables.enable = true;
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
    fd
    file
    exa
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
    python38Packages.virtualenvwrapper
    ripgrep
    rsync
    tcpdump
    tmux
    wget
    whois
    wireguard-tools
  ];
}
