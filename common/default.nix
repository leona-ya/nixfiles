{ pkgs, lib, ... }:

{
  imports = [
    ../users/em0lar
    ../users/root
    ./nginx.nix
  ];
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

  security.sudo.wheelNeedsPassword = false;

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
    file
    git
    gnupg
    htop
    iftop
    jq
    mtr
    neovim
    nmap
    python38Packages.virtualenvwrapper
    rsync
    tmux
    wget
    whois
    wireguard-tools
  ];
}
