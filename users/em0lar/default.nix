{ pkgs, lib, config, ... }:

{
  em0lar.sops.secrets."all/users/em0lar_pw".neededForUsers = true;
  users.users.em0lar = {
    uid = 1000;
    isNormalUser = true;
    extraGroups = [ "wheel" "bluetooth" "video" "audio" "docker" "libvirtd" ];
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAAEAQC5LY2Vp2jWD4O9rPeVHDzVGWS+tnwvguZ32BTu6m3b7XROhikF4UKSHiYF//AtZfuP2xTHTt+XWMzMghEf/GVkhJnA3YImg5+GtVCZwgsxKNs7RY47g6xtj962nxtqPkwUqXJI91QMLPSr5NlsyvImiyJjwNqO6SSFBgUIwa0lAgt3z5EroanHucMIOepcOQH+7GvZXrTfsxfxK5FJF6VCcDqT1UteCxzPMu29isugKo4nwZD7/jC/iXRXks9fMjjg3/bbiVJQcsIMrKhijd4pjMFjGLauz86/K55x+CcNuyGhaIdIdqt2mXnwfRX7uUlf3dushPZwtM7KpHtfQtBq4DcEsjqBqt6XYROmvx2fTenjdfo1vht37JLKi0KNqb+Nk9HJC2RQMHy+lf/OwsytbGyt3UB/2Vt7n4SqvGLyhXccU4sniyL9gDkjodB8bHTx7374rASDzjEfkT+SIbntdDQwQ+MFKiArqxOCKSiCLYgzxXdbGBhFp/pPkZJLArc7Sv6zpO8GUMjvtDPRpOEHcAU0UqIjvZPfYkSZoyuLXB0XOSdNQQ12S8OcR4fGlDMr2StjIbdKWa1xiMMa9AdXDD0B5uYn5jDX5Mfs1mRFySnp9Wd/PdecP3L6w09qGEe7LMSbD1ka79wyUZNcAKG1iRwtZrI2Bt/lrT1sEAL1HdEtEwX/0mBJoUzuopNoIito8EYwLiIzE+Bnlm6Yj+cQ1vVhxShUDIBxBbOJIiTtBrEqIQvcWABKQ5jns7ogWPA4K5JJUaRc5Q0ZSMd0iEwsUzVdQJfnSFP1h0YSjAtmLRX/N14Ut1E9UTbmpQdhC4+DwvPZClvpiinEdKo8CJcsRVoBEzWHhLSkLnSDsQvFC+RPkFiyITMKbuGpOItTosa81olliJBH/zG+4I+fR1jeWf8UfPAoqehON/dzdlGrGanNaqfU5tT1xMLccWyi18trfP7foL8/mjD0C8bMc4PL/sLiaDIRc6xBoOe0eCZWIpyC4k8onTyfX8zSef21jhEm642z03OFRiVTQN2zgWtrpSuqY4EV1+R24I0TIuzUKQJzcPqOmZIAXisLgIn2jQ7PM9yR8evfRTC9efY7yhAUoqD/7rmGTU0DZg9wrivFv1cyLGafBqXZhU+ZiyWz3S8kbUwpYFOL1MH4zTK/jUYOpaue34V3SlYnWB2RtzJocpC1eNSOgdUbHHnJzOIAful8JTjr4nSmvMKWpziwGAHoCtakapYHk9qJu8jLkX3u04hP2yVjLN5TO/aZXFdegTF5UNgA1f2IwYZNA0ofs/6ts54nlEUdkS5ibffVH5IHbHZi5AqFquDjK3NRHuBp523NxZTsHxrkBre28InXXrsP em0lar@em0lar.de"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDR9Kp84lHQRnaWU6gd8MHppZD3pQCI2TCeGF/kHm/A/kqADWqtTWjnD5ad1ZhOTSThCF35VGH3ICdnSCHh0uAHV7eK3GDjhxdrIJHY/WiubEpQJcS5OX/qTEn6QrPDIAZy2ykdHX7XrNWDGOlxpTjkPpHJmmDIQTZn/mMADuhVhIm03aFyVbUxpHSU+v7N8yxV5RehIw0RTy+qSjWcthDgTGPjPk1a2sElNVbsgF4VhqpdUfzG0BQCqr+zPDbeH66+gumDPXC5Pw4NQB596UWPDKaQv7juzveiPTpIjhTfpoWBjCmexGPbSYecXNee61NXe6HsGrGLtw/pRLEYVYH0ecU/b0A7TGd2gznKBgvk8xXoxkqHbDPoCPqC3moPD3BwCXTGNi6DBDAquC/Ho266AgZ+z83mP7TuDJmZ/F4f/glbb2hdZ6ITDS7Dvd+jGlw6UXlKeZThHOy+B1c9at4FeyQs6JBd4P5RwekUCF45gk0RfRu1+HE3YOXbN1s1DRXJs689DaBzTbD9rhROEjZgNT/m0VxC6w2i6WRvxcEvy+wL4HyJxdSK0MMVhZJza4MOB7qLvIq8z3L9kLDrKh6R49m+LsH7NCS9gh0wAH17E2cImSoX4IiRemn39oKZTplAwvvaGNXOmH/SqeZlGpYOL9Yn9nE5mC10/5In/KIZMQ== openpgp:0xF5B75815"
    ];
    shell = pkgs.zsh;
    passwordFile = lib.mkDefault config.sops.secrets."all/users/em0lar_pw".path;
  };

  home-manager.users.em0lar = {
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
        "vim" = "nvim";
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
          "virtualenvwrapper"
          "zsh-autocomplete"
        ];
        theme = lib.mkDefault "powerlevel10k/powerlevel10k";
        custom = builtins.toString (pkgs.stdenv.mkDerivation {
          name = "oh-my-zsh-custom-dir";
          buildInputs = with pkgs; [
            zsh-autocomplete
            zsh-powerlevel10k
          ];
          unpackPhase = "true";
          installPhase =
            ''
              mkdir -p $out/themes
              ln -s ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k $out/themes/powerlevel10k
              mkdir -p $out/plugins
              ln -s ${pkgs.zsh-autocomplete}/share/zsh-autocomplete $out/plugins/zsh-autocomplete
            '';
        });
      };
    };

    programs.git = {
      enable = true;
      userName = "Leo Maroni";
      userEmail = "git@em0lar.de";
      signing.signByDefault = true;
      signing.key = "430411806903447FF65FCBCBB1ADA545CD2CBACD";
      ignores = [
        ".venv"
        ".idea"
        ".tmp"
        "*.iml"
      ];
      extraConfig = {
        init = {
          defaultBranch = "main";
        };
        tag = {
          gpgSign = true;
        };
        pull = {
          ff = "only";
        };
        transfer = {
          fsckObjects = true;
        };
        feature.manyFiles = true;
      };
    };

    programs.ssh = {
      enable = true;
      matchBlocks = let
        em0lar = {
          port = 61337;
        };
        em0lar-nyo = {
          proxyCommand = "ssh -W root@%h:22 nyo.net.em0lar.dev";
        };
        em0lar-gitea = {
          port = 2222;
          extraOptions.PubkeyAcceptedKeyTypes = "+ssh-rsa";
        };
      in {
        "git.em0lar.dev" = em0lar-gitea;
        "*.em0lar.dev" = em0lar;
        "*.nyo.net.em0lar.dev" = em0lar-nyo;
        "*.lan" = em0lar;
      };
    };
  };
}

