{ options, pkgs, lib, ... }:

{
  imports = [
    ../users/em0lar
    ../users/root
    ../users/e1mo
    ./nginx.nix
  ];
  users.mutableUsers = false;
  home-manager.useUserPackages = true;
  home-manager.useGlobalPkgs = true;
  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    trustedUsers = [ "root" "@wheel" "em0lar" ];
    gc = {
      automatic = lib.mkDefault true;
      options = lib.mkDefault "--delete-older-than 7d";
    };
  };

  services.journald.extraConfig = "SystemMaxUse=256M";

  services.openssh.enable = true;
  services.openssh.ports = [ 61337 ];
  services.openssh.passwordAuthentication = false;
  services.openssh.challengeResponseAuthentication = false;
  services.openssh.permitRootLogin = lib.mkDefault "no";
  services.iperf3.enable = true;
  services.iperf3.openFirewall = true;

  security.sudo.wheelNeedsPassword = lib.mkDefault false;

  time.timeZone = "Europe/Berlin";

  environment.variables.EDITOR = "nvim";
  programs.zsh.enable = true;

  networking.useNetworkd = true;
  em0lar.nftables.enable = true;
  networking.useDHCP = false;
  services.resolved.extraConfig = ''
    FallbackDNS=
    Cache=no-negative
  '';

  environment.systemPackages = with pkgs; [
    bat
    bind.dnsutils # for dig
    fd
    file
    exa
    git
    gnupg
    gptfdisk
    htop
    iftop
    iperf
    jq
    lm_sensors
    mtr
    neovim
    nmap
    python38Packages.virtualenvwrapper
    ripgrep
    rsync
    tcpdump
    tmux
    wget2
    whois
    wireguard-tools
  ];
}
