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
    bind.dnsutils # for dig
    file
    git
    gnupg
    htop
    rsync
    wget
    whois
    neovim
    tmux
    mtr
    bat
    jq
    python38Packages.virtualenvwrapper
  ];
}
