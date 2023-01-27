{ lib, pkgs, ... }: {
  users.users.leona = {
    isNormalUser = true;
    extraGroups = [ "wheel" "bluetooth" "video" "audio" "docker" "libvirtd" "dialout" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILN9nTU+lsrfp+uLo1IvMEIi64m6ke0FmfZ6FxBgmKXp leona@leona.is"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOkvy9P1Qweq1kykgn3IWIBWe/v/dTNAx+hd9i2aKe1O openpgp:0xCACA6CB6"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDR9Kp84lHQRnaWU6gd8MHppZD3pQCI2TCeGF/kHm/A/kqADWqtTWjnD5ad1ZhOTSThCF35VGH3ICdnSCHh0uAHV7eK3GDjhxdrIJHY/WiubEpQJcS5OX/qTEn6QrPDIAZy2ykdHX7XrNWDGOlxpTjkPpHJmmDIQTZn/mMADuhVhIm03aFyVbUxpHSU+v7N8yxV5RehIw0RTy+qSjWcthDgTGPjPk1a2sElNVbsgF4VhqpdUfzG0BQCqr+zPDbeH66+gumDPXC5Pw4NQB596UWPDKaQv7juzveiPTpIjhTfpoWBjCmexGPbSYecXNee61NXe6HsGrGLtw/pRLEYVYH0ecU/b0A7TGd2gznKBgvk8xXoxkqHbDPoCPqC3moPD3BwCXTGNi6DBDAquC/Ho266AgZ+z83mP7TuDJmZ/F4f/glbb2hdZ6ITDS7Dvd+jGlw6UXlKeZThHOy+B1c9at4FeyQs6JBd4P5RwekUCF45gk0RfRu1+HE3YOXbN1s1DRXJs689DaBzTbD9rhROEjZgNT/m0VxC6w2i6WRvxcEvy+wL4HyJxdSK0MMVhZJza4MOB7qLvIq8z3L9kLDrKh6R49m+LsH7NCS9gh0wAH17E2cImSoX4IiRemn39oKZTplAwvvaGNXOmH/SqeZlGpYOL9Yn9nE5mC10/5In/KIZMQ== openpgp:0xF5B75815"
    ];
    shell = pkgs.zsh;
  };

  home-manager.users.leona = {
    home.stateVersion = "22.05";
    manual.manpages.enable = false;

    programs.zsh = {
      enable = true;
      plugins = [{
        name = "zsh-nix-shell";
        file = "nix-shell.plugin.zsh";
        src = pkgs.fetchFromGitHub {
          owner = "chisui";
          repo = "zsh-nix-shell";
          rev = "v0.2.0";
          sha256 = "sha256-qWcr49m8R3yUQcJUXDhQE/ziIBLunSF32Pz+IezL3r0=";
        };
      }];
      shellAliases = {
        "tb" = "nc termbin.com 9999";
        "ip" = "ip -c";
        "watch" = "watch -c";
        "xtssh" = "TERM=xterm-256color ssh";
        "use" = "nix-shell -p ";
        "cat" = "bat --style=header ";
        "grep" = "rg";
        "l" = "exa";
        "ls" = "exa";
        "ll" = "exa -l";
        "la" = "exa -la --git";
        "tree" = "exa -T";
        "sudo" = "sudo ";
        "wt" = "wget";
      };
      initExtra = builtins.readFile ../zsh-extra.zsh;
      oh-my-zsh = {
        enable = true;
        plugins = [
          "gitfast"
          "git"
          "sudo"
        ];
        theme = lib.mkDefault "powerlevel10k/powerlevel10k";
        custom = builtins.toString (pkgs.stdenv.mkDerivation {
          name = "oh-my-zsh-custom-dir";
          buildInputs = with pkgs; [
            zsh-powerlevel10k
          ];
          unpackPhase = "true";
          installPhase =
            ''
              mkdir -p $out/themes
              ln -s ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k $out/themes/powerlevel10k
            '';
        });
      };
    };

    programs.git = {
      enable = true;
      userName = "Leona Maroni";
      userEmail = "dev@leona.is";
      signing.signByDefault = true;
      signing.key = "EB5CEED62922C6050F9FC85BD5B08ADFC75E3605";
      ignores = [
        ".venv"
        ".idea"
        ".tmp"
        "*.iml"
      ];
      extraConfig = {
        init.defaultBranch = "main";
        tag.gpgSign = true;
        pull.ff = "only";
        transfer.fsckObjects = true;
        feature.manyFiles = true;
      };
    };

    programs.ssh = {
      enable = true;
      matchBlocks = let
        leona = {
          port = 54973;
          forwardAgent = true;
        };
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
      in {
        "git.yuka.dev" = yuka-gitea;
        "thia.wg.net.leona.is" = leona-desktop;
        "*.net.leona.is" = leona;
      };
    };
  };
}
