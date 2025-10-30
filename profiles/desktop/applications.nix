{
  lib,
  pkgs,
  config,
  ...
}:

{
  boot.supportedFilesystems = [ "cifs" ];
  fonts.fontconfig.localConf = lib.fileContents ./fontconfig.xml;
  fonts.fontconfig.defaultFonts = {
    emoji = [ "Noto Color Emoji" ];
    serif = [ "DejaVu Serif" ];
    sansSerif = [ "DejaVu Sans" ];
    monospace = [ "Monaspace Argon 8" ];
  };
  fonts.packages = with pkgs; [
    noto-fonts-color-emoji
    dejavu_fonts
    fira
    fira-mono
    unifont
    roboto
    jetbrains-mono
    font-awesome
    meslo-lgs-nf
    inter
    questrial-regular
    monaspace
    annieuseyourtelescope
    vista-fonts
    source-sans-pro
  ];

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    libusb-compat-0_1
    lm_sensors
    wl-clipboard
    xdg-utils
  ];

  users.users.leona.packages = with pkgs; [
    anki
    #calibre
    editorconfig-checker
    element-desktop
    evince
    feh
    gimp3
    eog
    nautilus
    clang
    cmake
    gtest
    gtest.dev
    gnumake
    gh
    inkscape
    jetbrains.idea-ultimate
    jetbrains.rust-rover
    #    kicad
    libimobiledevice
    llvm
    lldb
    onlyoffice-desktopeditors
    nodejs
    #nheko
    mpv
    (wrapOBS {
      plugins = with obs-studio-plugins; [ wlrobs ];
    })
    obsidian
    opentofu
    openssl_3
    pandoc
    pass-wayland
    pre-commit
    podman-compose
    poetry
    python3
    qFlipper
    rofi-pass
    rustup
    speedcrunch
    spotify
    sublime-merge
    texlab
    texlive.combined.scheme-full
    thunderbird
    virt-manager
    yarn
    yt-dlp
    zoxide
    #    (zoom-us.overrideAttrs (old: {
    #      postFixup = old.postFixup + ''
    #        wrapProgram $out/bin/zoom --unset XDG_SESSION_TYPE --set QT_QPA_PLATFORM xcb
    #      '';
    #    }))

    # nixpkgs tools
    nixfmt
    nixfmt-tree
    nix-output-monitor
    nix-init
    nurl
    nix-update
    nix-tree
    nixpkgs-review
  ];

  #boot.extraModulePackages = [ config.boot.kernelPackages.v4l2loopback ];
  #boot.kernelModules = [
  #  "v4l2loopback"
  #];
  #boot.extraModprobeConfig = ''
  #  options v4l2loopback devices=2 exclusive_caps=1
  #'';

  services.fwupd.enable = true;

  services.udev.packages = [
    pkgs.yubikey-personalization
    pkgs.qFlipper
  ];
  environment.variables.MOZ_USE_XINPUT2 = "1"; # for firefox
  hardware.bluetooth.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
  };
  services.gnome.gnome-keyring.enable = true;
  programs.seahorse.enable = true;
  services.udisks2.enable = true;
  programs.gnome-disks.enable = true;
  programs.kdeconnect.enable = true;
  programs.nix-ld.enable = true;
  services.avahi = {
    enable = true;
    nssmdns4 = true;
  };
  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = [ "leona" ];
  };
  #services.pcscd.enable = true;

  home-manager.users.leona = {
    xdg.enable = true;
    gtk = {
      enable = true;
      iconTheme.name = "Adwaita";
      iconTheme.package = pkgs.adwaita-icon-theme;
      theme = {
        name = "Adwaita";
        package = pkgs.gnome-themes-extra;
      };
      gtk3.extraConfig = {
        gtk-font-name = "DejaVu Sans 11";
      };
      gtk4.extraConfig = {
      };
    };
    programs.gpg.enable = true;
    services.gpg-agent = {
      enable = true;
      enableSshSupport = true;
      defaultCacheTtlSsh = 15;
      maxCacheTtlSsh = 300;
      defaultCacheTtl = 5;
      maxCacheTtl = 30;
      pinentry.package = pkgs.pinentry-gnome3;
      enableExtraSocket = true;
      sshKeys = [
        "F18DB4002D5F6A2E62BF9F4E6361BB12143B6647" # D5B08ADFC75E3605
        "D4D2099A8A2FEE7D8B83989134B46C984C6FAF2D" # F0E55407FC6FF7BA
      ];
    };
    programs.chromium = {
      enable = false;
      package = pkgs.symlinkJoin {
        name = "chromium";
        paths = [ pkgs.chromium ];
        buildInputs = [ pkgs.makeWrapper ];
        postBuild = ''
          wrapProgram $out/bin/chromium --add-flags "--enable-features=WebUIDarkMode --force-dark-mode"
        '';
      };
      extensions = [
        { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; } # ublock origin
      ];
    };
    programs.password-store.enable = true;
    programs.zsh = {
      initContent = ''
        eval "$(${pkgs.zoxide}/bin/zoxide init zsh)"
        eval "$(direnv hook zsh)"
      '';
      shellAliases = {
        "pdev" = "pandoc --template eisvogel --listings";
      };
    };
    home.file.".pandoc/templates".source = (
      pkgs.stdenv.mkDerivation (finalAttrs: {
        pname = "pandoc-templates";
        version = "3.1.0";
        src = pkgs.fetchzip {
          url = "https://github.com/Wandmalfarbe/pandoc-latex-template/releases/download/v${finalAttrs.version}/Eisvogel-${finalAttrs.version}.tar.gz";
          hash = "sha256-THszG9id3Ditrf4f0csu4Sl75P90ZkXENbGytGjp7O8=";
        };
        installPhase = ''
          mkdir -p $out
          cp eisvogel.latex $out
          cp eisvogel.beamer $out
        '';
      })
    );
    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
      config.global.load_dotenv = false;
    };

    xdg.configFile."mimeapps.list".force = true;
    xdg.mimeApps = {
      enable = true;
      defaultApplications = {
        "text/html" = [ "firefox.desktop" ];
        "x-scheme-handler/http" = [ "firefox.desktop" ];
        "x-scheme-handler/https" = [ "firefox.desktop" ];
        "x-scheme-handler/about" = [ "firefox.desktop" ];
        "x-scheme-handler/unknown" = [ "firefox.desktop" ];
        "image/avif" = [ "org.gnome.eog.desktop" ];
        "image/jpeg" = [ "org.gnome.eog.desktop" ];
        "image/png" = [ "org.gnome.eog.desktop" ];
        "image/svg+xml" = [ "org.gnome.eog.desktop" ];
        "application/pdf" = [ "org.gnome.Evince.desktop" ];
      };
    };
    services.nextcloud-client = {
      enable = true;
      #      startInBackground = true;
    };

    ## Sublime
    xdg.configFile."sublime-merge/Packages/Monokai Color Scheme" = {
      recursive = true;
      source = pkgs.fetchFromGitHub {
        owner = "bitsper2nd";
        repo = "sublime-monokai-scheme";
        rev = "013007ee96490cdc4485167f9b3026e05430a890";
        sha256 = "sha256-tdQvrUUp3ZtpFjb/stzA8IEP536eqaUGr4Lc1KLfF5k=";
      };
    };
    xdg.configFile."sublime-merge/Packages/Monokai Theme" = {
      recursive = true;
      source = pkgs.fetchFromGitHub {
        owner = "bitsper2nd";
        repo = "merge-monokai-theme";
        rev = "05d45fd8527f2a569eef87c8d3e607907e546a7b";
        sha256 = "sha256-NZzXQJlWOGZf1LXV+1g+mjccNSSAC0PzNgCcH61YB3A=";
      };
    };
    xdg.configFile."sublime-merge/Packages/User/Preferences.sublime-settings".text = ''
      {
        "color_scheme": "Packages/Monokai Color Scheme/Monokai Plus.sublime-color-scheme",
        "theme": "Monokai Plus.sublime-theme"
      }
    '';
    xdg.configFile."sublime-merge/Packages/User/Default.sublime-commands".text = ''
      [
          {
              "caption": "Change Theme: Monokai",
              "command": "set_preference",
              "args": {
                  "setting": "theme",
                  "value": "Monokai Plus.sublime-theme"
              },
          }
      ]
    '';

    # dev envs
    home.file = {
      ".envs/openjdk17".source = "${pkgs.jdk17}/lib/openjdk";
      ".envs/openjdk21".source = "${pkgs.jdk21}/lib/openjdk";
      ".envs/go".source = "${pkgs.go}";
      ".envs/python312".source = "${pkgs.python312}";
      ".envs/nodejs".source = "${pkgs.nodejs}";
    };
  };
  environment.variables.RUST_SRC_PATH = "${pkgs.rust.packages.stable.rustPlatform.rustLibSrc}";
  services.printing = {
    enable = true;
    drivers = [
      pkgs.gutenprint
      pkgs.cups-brother-hll2350dw
      pkgs.cups-brother-ptouch
      pkgs.hplip
      pkgs.splix
    ];
  };
  programs.steam.enable = true;
  hardware.keyboard.zsa.enable = true;
  boot.binfmt.emulatedSystems = [
    "aarch64-linux"
    "i686-linux"
  ];
}
