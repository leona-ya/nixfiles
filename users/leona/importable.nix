{ config, lib, pkgs, ... }: {
  users.users.leona = (lib.mkMerge [
    {
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILN9nTU+lsrfp+uLo1IvMEIi64m6ke0FmfZ6FxBgmKXp leona@leona.is"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOkvy9P1Qweq1kykgn3IWIBWe/v/dTNAx+hd9i2aKe1O openpgp:0xCACA6CB6"
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDR9Kp84lHQRnaWU6gd8MHppZD3pQCI2TCeGF/kHm/A/kqADWqtTWjnD5ad1ZhOTSThCF35VGH3ICdnSCHh0uAHV7eK3GDjhxdrIJHY/WiubEpQJcS5OX/qTEn6QrPDIAZy2ykdHX7XrNWDGOlxpTjkPpHJmmDIQTZn/mMADuhVhIm03aFyVbUxpHSU+v7N8yxV5RehIw0RTy+qSjWcthDgTGPjPk1a2sElNVbsgF4VhqpdUfzG0BQCqr+zPDbeH66+gumDPXC5Pw4NQB596UWPDKaQv7juzveiPTpIjhTfpoWBjCmexGPbSYecXNee61NXe6HsGrGLtw/pRLEYVYH0ecU/b0A7TGd2gznKBgvk8xXoxkqHbDPoCPqC3moPD3BwCXTGNi6DBDAquC/Ho266AgZ+z83mP7TuDJmZ/F4f/glbb2hdZ6ITDS7Dvd+jGlw6UXlKeZThHOy+B1c9at4FeyQs6JBd4P5RwekUCF45gk0RfRu1+HE3YOXbN1s1DRXJs689DaBzTbD9rhROEjZgNT/m0VxC6w2i6WRvxcEvy+wL4HyJxdSK0MMVhZJza4MOB7qLvIq8z3L9kLDrKh6R49m+LsH7NCS9gh0wAH17E2cImSoX4IiRemn39oKZTplAwvvaGNXOmH/SqeZlGpYOL9Yn9nE5mC10/5In/KIZMQ== openpgp:0xF5B75815"
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
      };
      initExtra = ''
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
        git.sign-on-push = true;
        signing = {
          backend = lib.mkDefault "gpg";
          key = lib.mkDefault "EB5CEED62922C6050F9FC85BD5B08ADFC75E3605";
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
