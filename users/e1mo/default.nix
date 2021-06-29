{ pkgs, lib, ... }:

{
  users.users.e1mo = {
    isNormalUser = true;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBfbb4m4o89EumFjE8ichX03CC/mWry0JYaz91HKVJPb e1mo"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID9x/kL2fFqQSEyFvdEgiM2UKYAZyV1oct9alS6mweVa e1mo (ssh_0x6D617FD0A85BAADA)"
    ];
    shell = pkgs.zsh;
    hashedPassword = "!";
  };

  home-manager.users.e1mo = {
    manual.manpages.enable = false;

    programs.zsh = {
      enable = true;
      plugins = [{
        name = "zsh-nix-shell";
        file = "nix-shell.plugin.zsh";
        src = pkgs.fetchFromGitHub {
          owner = "chisui";
          repo = "zsh-nix-shell";
          rev = "v0.1.0";
          sha256 = "0snhch9hfy83d4amkyxx33izvkhbwmindy0zjjk28hih1a9l2jmx";
        };
      }];
      shellAliases = {
        "tb" = "nc termbin.com 9999";
        "vim" = "nvim";
        "ip" = "ip -c";
        "watch" = "watch -c";
        "xtssh" = "TERM=xterm-256color ssh";
        "leo" = "echo $(whoami) is cute!";
      };
      oh-my-zsh = {
        enable = true;
        plugins = [
          "git"
          "sudo"
          "virtualenvwrapper"
        ];
        theme = lib.mkDefault "fishy";
      };
    };

    programs.git = {
      enable = true;
      userName = "Moritz Fromm";
      userEmail = "git@e1mo.de";
      signing.signByDefault = false;
      signing.key = "67BEE56343B6420D550EDF2A6D617FD0A85BAADA";
      ignores = [
        ".venv"
        ".idea"
        ".tmp"
        "*.iml"
        "*.swp"
      ];
      extraConfig = {
        init = {
          defaultBranch = "main";
        };
        tag = {
          gpgSign = false;
        };
        pull = {
          ff = "only";
        };
        transfer = {
          fsckObjects = true;
        };
      };
    };

    programs.ssh = {
      enable = true;
      matchBlocks = let
        em0lar = {
          port = 61337;
        };
      in {
        "*.em0lar.dev" = em0lar;
      };
    };
  };
}

