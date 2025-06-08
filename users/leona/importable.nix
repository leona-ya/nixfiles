{ config, lib, pkgs, ... }: {
  users.users.leona = (lib.mkMerge [
    {
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOkvy9P1Qweq1kykgn3IWIBWe/v/dTNAx+hd9i2aKe1O openpgp:0xCACA6CB6"
        "ecdsa-sha2-nistp384 AAAAE2VjZHNhLXNoYTItbmlzdHAzODQAAAAIbmlzdHAzODQAAABhBOMNkfG3xFDgwLs+aj9n/UXw5Feww1dZG7K/wUbsNHpybzgWcb4t/387aKbu9vu3TwOYdDWj6zaE2pytjQi9/ltz11ybNm3djwbp142fn9Cr8rmbqL5aK6vNbMmR+pM5QA== openpgp:0x2611E806"
      ];
      shell = pkgs.zsh;
    }
    (lib.mkIf config.nixpkgs.hostPlatform.isLinux {
      extraGroups = [ "wheel" "bluetooth" "video" "audio" "docker" "libvirtd" "dialout" ];
      isNormalUser = true;
    })
    (lib.mkIf config.nixpkgs.hostPlatform.isDarwin {
      home = "/Users/leona";
    })
  ]);

  home-manager.users.leona = {
    home.stateVersion = "22.05";
    manual.manpages.enable = false;

    nix.gc = {
      automatic = true;
      options = "--delete-older-than 7d";
      persistent = true;
    };

    programs.zsh = {
      enable = true;
      shellAliases = {
        "tb" = "nc termbin.com 9999";
        "ip" = "ip -c";
        "watch" = "watch -c";
        "xtssh" = "TERM=xterm-256color ssh";
        "cat" = "bat --style=header ";
        "grep" = "rg";
        "l" = "eza";
        "ls" = "eza";
        "ll" = "eza -l";
        "la" = "eza -la --git";
        "tree" = "eza -T";
        "sudo" = "sudo ";
        "wt" = "wget";
        "nb-fc" = "nom-build --option extra-substituters https://s3.whq.fcio.net/hydra --option trusted-public-keys flyingcircus.io-1:Rr9CwiPv8cdVf3EQu633IOTb6iJKnWbVfCC8x8gVz2o=";
      };
      initContent = ''
        function use {
          packages=()
          packages_fmt=()
          while [ "$#" -gt 0 ]; do
            i="$1"; shift 1
            packages_fmt+=$(echo $i | ${pkgs.gnused}/bin/sed 's/[a-zA-Z]*#//')
            [[ $i =~ [a-zA-Z]*#[a-zA-Z]* ]] || i="nixpkgs#$i"
            packages+=$i
          done
          env prompt_sub="%F{blue}($packages_fmt) %F{white}$PROMPT" nix shell $packages
        }
      '';
      oh-my-zsh = {
        enable = true;
        plugins = [
          "git"
          "sudo"
        ];
      };
      autosuggestion.enable = true;
    };

    programs.starship = {
      enable = true;
      settings = {
        character = {
          success_symbol = "[λ](bold green)";
          error_symbol = "[λ](bold red)";
        };
        directory.read_only = " 󰌾";
        docker_context.symbol = " ";
        elixir.symbol = " ";
        git_branch.symbol = " ";
        git_commit.tag_symbol = "  ";
        golang.symbol = " ";
        haskell.symbol = " ";
        hostname.format = "@[$hostname]($style) ";
        nix_shell.symbol = " ";
        python.symbol = " ";
        rust.symbol = "󱘗 ";
        username.format = "[$user]($style) ";
      };
    };

    programs.git = {
      enable = true;
      userName = "Leona Maroni";
      userEmail = lib.mkDefault "dev@leona.is";
      signing.signByDefault = true;
      signing.key = lib.mkDefault "EB5CEED62922C6050F9FC85BD5B08ADFC75E3605";
      ignores = [
        ".venv"
        ".idea"
        ".tmp"
        "*.iml"
        ".leona"
      ];
      extraConfig = {
        init.defaultBranch = "main";
        tag.gpgSign = true;
        pull.ff = "only";
        transfer.fsckObjects = true;
        feature.manyFiles = true;
        push.autoSetupRemote = true;
        diff.external = "difft";
      };
    };

    programs.jujutsu = {
      enable = true;
      settings = {
        git = {
          sign-on-push = true;
        };
        signing = {
          backend = lib.mkDefault "gpg";
          key = lib.mkDefault "B50CB5BA6A620411098CD9C8F0E55407FC6FF7BA";
        };
        user = {
          name = "Leona Maroni";
          email = lib.mkDefault "dev@leona.is";
        };
        ui.diff.tool = [
          "difft"
          "--color=always"
          "$left"
          "$right"
        ];
      };
    };

    programs.ssh = {
      enable = true;
      matchBlocks =
        let
          leona.port = 54973;
          leona-desktop = {
            port = 54973;
            forwardAgent = true;
            extraOptions = {
              RemoteForward = "/run/user/1000/gnupg/S.gpg-agent /run/user/1000/gnupg/S.gpg-agent.extra";
            };
          };
          yuka-gitea = {
            extraOptions.PubkeyAcceptedKeyTypes = "+ssh-rsa";
          };
        in
        {
          "git.yuka.dev" = yuka-gitea;
          "thia.wg.net.leona.is" = leona-desktop;
          "*.net.leona.is" = leona;
        };
    };
  };
}
