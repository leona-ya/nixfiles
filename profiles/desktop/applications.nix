{ lib, pkgs, config, ... }:

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
    noto-fonts-emoji
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
    vistafonts
  ];

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    libusb-compat-0_1
    lm_sensors
    wl-clipboard
    xdg-utils
  ];

  nixpkgs.config.permittedInsecurePackages = [
    "electron-25.9.0"
    "openssl-1.1.1w"
  ];

  users.users.leona.packages = with pkgs; [
    bitwarden
    calibre
    cachix
    element-desktop
    evince
    feh
    gcc11
    gimp
    gnome.eog
    gnome.nautilus
    gnome.vinagre
    cmake
    gnumake
    gh
    inkscape
    (jetbrains.idea-ultimate.override {
      jdk = jetbrains.jdk;
    })
    (jetbrains.rust-rover.override {
      jdk = jetbrains.jdk;
    })
#    kicad
    libimobiledevice
    onlyoffice-bin
    nheko
    mpv
    (wrapOBS {
      plugins = with obs-studio-plugins; [ wlrobs ];
    })
    obsidian
    openssl_3_0
    openttd
    pandoc
    pass-wayland
    podman-compose
    poetry
    python3
    qFlipper
    rofi-pass
    rustup
    signal-desktop
    speedcrunch
    spotify
    sublime-merge
    superTuxKart
    tectonic
    texlab
    texlive.combined.scheme-full
    thunderbird
    virt-manager
    youtube-dl
    zoxide fzf
#    (zoom-us.overrideAttrs (old: {
#      postFixup = old.postFixup + ''
#        wrapProgram $out/bin/zoom --unset XDG_SESSION_TYPE --set QT_QPA_PLATFORM xcb
#      '';
#    }))

    # nixpkgs tools
    nix-output-monitor
    nix-init
    nurl
    nix-tree
    nixpkgs-review
  ];

  boot.extraModulePackages = [ config.boot.kernelPackages.v4l2loopback ];
  boot.kernelModules = [
    "v4l2loopback"
  ];
  boot.extraModprobeConfig = ''
    options v4l2loopback devices=2 exclusive_caps=1
  '';

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
  services.avahi = {
    enable = true;
    nssmdns4 = true;
  };
  #services.pcscd.enable = true;

  home-manager.users.leona = {
    xdg.enable = true;
    gtk = {
      enable = true;
      iconTheme.name = "Adwaita";
      iconTheme.package = pkgs.gnome.adwaita-icon-theme;
      theme = {
        name = "Adwaita";
        package = pkgs.gnome.gnome-themes-extra;
      };
      gtk3.extraConfig = {
        gtk-application-prefer-dark-theme = true;
        gtk-font-name = "DejaVu Sans 11";
      };
      gtk4.extraConfig = {
        gtk-application-prefer-dark-theme = 1;
      };
    };
    programs.gpg.enable = true;
    services.gpg-agent = {
      enable = true;
      enableSshSupport = true;
      pinentryPackage = pkgs.pinentry-gnome3;
      enableExtraSocket = true;
      sshKeys = [
	      "F18DB4002D5F6A2E62BF9F4E6361BB12143B6647" # leona
      ];
    };
    programs.chromium = {
      enable = true;
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
        { id = "nngceckbapebfimnlniiiahkandclblb"; } # bitwarden
     ];
    };
    programs.password-store.enable = true;
    programs.zsh = {
      initExtra = ''
        eval "$(${pkgs.zoxide}/bin/zoxide init zsh)"
        eval "$(direnv hook zsh)"
      '';
      shellAliases = {
        "pdev" = "pandoc --template eisvogel --listings";
      };
    };
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
    };
  };
  environment.variables.RUST_SRC_PATH = "${pkgs.rust.packages.stable.rustPlatform.rustLibSrc}";
  services.printing = {
    enable = true;
    drivers = [
      pkgs.gutenprint
      pkgs.cups-brother-hll2350dw
      pkgs.cups-brother-ptouch
    ];
  };
  programs.steam.enable = true;
  hardware.keyboard.zsa.enable = true;
  boot.binfmt.emulatedSystems = [ "aarch64-linux" "i686-linux" ];
  networking.hosts = {
    "fd8f:d15b:9f40:101::1312" = [ "cloud.leona.is" ];
  };
}
