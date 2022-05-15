{ options, pkgs, lib, config, ... }:

{
  imports = [
    ../users/root
    ../users/leona
    ./nginx.nix
  ];
  users.mutableUsers = false;
  home-manager.useUserPackages = true;
  home-manager.useGlobalPkgs = true;
  l.sops.secrets."all/nix-build/builder_ssh_key".owner = "root";
  nix = {
    package = (pkgs.nix.overrideAttrs(old: rec {
      version = "2.8.1";
      sha256 = "sha256-zldZ4SiwkISFXxrbY/UdwooIZ3Z/I6qKxtpc3zD0T/o=";
      src = pkgs.fetchFromGitHub { owner = "NixOS"; repo = "nix"; rev = version; inherit sha256; };
    }));
    extraOptions = ''
      experimental-features = nix-command flakes
      builders-use-substitutes = true
    '';
    settings.trusted-users = [ "root" "@wheel" "leona" ];
    gc = {
      automatic = lib.mkDefault true;
      options = lib.mkDefault "--delete-older-than 7d";
    };
    buildMachines = [{
     hostName = "hack.net.leona.is";
     system = "x86_64-linux";
     maxJobs = 5;
     speedFactor = 2;
     supportedFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
     # publicHostKey not working
     sshUser = "nix-builder";
     sshKey = config.sops.secrets."all/nix-build/builder_ssh_key".path;
    }];
    distributedBuilds = lib.mkDefault true;
  };
  programs.ssh.knownHosts."[hack.net.leona.is]:54973".publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ8wPC4wXbgPdXwOF+7VSNQW/RL62gN6LrHgUDqq/f1N";

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
