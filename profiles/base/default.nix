{ pkgs, lib, config, ... }:

{
  imports = [
    ../../users/root
    ../../users/leona
    ./nginx.nix
    ./nvim.nix
  ];
  users.mutableUsers = false;
  home-manager.useUserPackages = true;
  home-manager.useGlobalPkgs = true;
  l.sops.secrets."all/nix-build/builder_ssh_key".owner = "root";
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
  programs.ssh.knownHosts."[hack.net.leona.is]:54973".publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDUbA/xZ2Cy/tuSCR46aEXCWtY2ixe+6P7Gk8hTfesNu";

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
