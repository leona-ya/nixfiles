{ options, pkgs, lib, ... }:

{
  imports = [
    ../users/root
    ../users/leona
    ./nginx.nix
  ];
  users.mutableUsers = false;
  home-manager.useUserPackages = true;
  home-manager.useGlobalPkgs = true;
  nix = {
    package = pkgs.nixUnstable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    settings.trusted-users = [ "root" "@wheel" "leona" ];
    gc = {
      automatic = lib.mkDefault true;
      options = lib.mkDefault "--delete-older-than 7d";
    };
  };

  services.journald.extraConfig = "SystemMaxUse=256M";

  services.openssh.enable = true;
  services.openssh.ports = [ 54973 ];
  services.openssh.passwordAuthentication = false;
  services.openssh.kbdInteractiveAuthentication = false;
  services.openssh.permitRootLogin = lib.mkDefault "no";
  services.iperf3.enable = true;
  services.iperf3.openFirewall = true;

  security.sudo.wheelNeedsPassword = lib.mkDefault false;

  time.timeZone = "Europe/Berlin";

  environment.variables.EDITOR = "nvim";
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
