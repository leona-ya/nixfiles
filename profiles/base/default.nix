{
  inputs,
  pkgs,
  lib,
  config,
  ...
}:

{
  imports = [
    ../../users/leona
    ./helix.nix
    ./bat.nix
    ../../modules/meta
    ../../modules/sops
  ];

  nixpkgs.overlays = lib.attrValues inputs.self.overlays;
  nix.registry.nixpkgs.flake = inputs.nixpkgs;
  nix.nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];

  nixpkgs.config.permittedInsecurePackages = [
    "olm-3.2.16"
  ];

  security.pki.certificateFiles = [ ../../lib/leona-is-ca.crt ];
  home-manager.useUserPackages = true;
  home-manager.useGlobalPkgs = true;
  nixpkgs.config.allowUnfree = true;
  nix = {
    package = pkgs.lix;
    settings = {
      auto-optimise-store = true;
      experimental-features = [
        "nix-command"
        "flakes"
        "pipe-operator"
      ];
      builders-use-substitutes = true;
      trusted-users = [
        "root"
        "@wheel"
        "leona"
      ];
    };
    gc = {
      automatic = lib.mkDefault true;
      options = lib.mkDefault "--delete-older-than 7d";
    };
  };

  environment.variables.EDITOR = "hx";
  programs.zsh.enable = true;

  environment.systemPackages = with pkgs; [
    bat
    bottom
    bind.dnsutils # for dig
    difftastic
    fd
    file
    eza
    git
    gnupg
    gptfdisk
    htop
    iperf
    mtr
    nmap
    openssl
    ripgrep
    rsync
    sshfs
    tcpdump
    tmux
    yq-go
    whois
  ];
}
