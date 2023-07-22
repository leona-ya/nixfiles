{ lib, pkgs, config, ... }:

{
  boot.supportedFilesystems = [ "cifs" ];
  fonts.fontconfig.localConf = lib.fileContents ./fontconfig.xml;
  fonts.fontconfig.defaultFonts = {
    emoji = [ "Noto Color Emoji" ];
    serif = [ "DejaVu Serif" ];
    sansSerif = [ "DejaVu Sans" ];
    monospace = [ "JetBrains Mono 8" ];
  };
  fonts.fonts = with pkgs; [
    noto-fonts-emoji
    dejavu_fonts
    fira-mono
    unifont
    roboto
    jetbrains-mono
    font-awesome
    meslo-lgs-nf
    inter
  ];

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    libusb-compat-0_1
    lm_sensors
    wl-clipboard
    xdg-utils
  ];

  users.users.leona.packages = with pkgs; [
    bitwarden
    calibre
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
#    kicad
    libreoffice-fresh
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
    postman
    poetry
    python3
    qFlipper
    rofi-pass
    rustup
    signal-desktop
    speedcrunch
    spotify
    superTuxKart
    tectonic
    texlab
    texlive.combined.scheme-full
    thunderbird-wayland
    virt-manager
    youtube-dl
    zoxide fzf
#    (zoom-us.overrideAttrs (old: {
#      postFixup = old.postFixup + ''
#        wrapProgram $out/bin/zoom --unset XDG_SESSION_TYPE --set QT_QPA_PLATFORM xcb
#      '';
#    }))
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
  services.avahi = {
    enable = true;
    nssmdns = true;
  };
  #services.pcscd.enable = true;

  home-manager.users.leona = {
    xdg.enable = true;
    gtk = {
      enable = true;
      iconTheme.name = "Qogir-dark";
      iconTheme.package = pkgs.qogir-icon-theme;
      theme = {
        name = "Qogir-dark";
        package = pkgs.qogir-theme;
      };
      gtk3.extraConfig = {
        gtk-application-prefer-dark-theme = true;
      };
      gtk4.extraConfig = {
        gtk-application-prefer-dark-theme = 1;
      };
    };
    programs.gpg.enable = true;
    services.gpg-agent = {
      enable = true;
      enableSshSupport = true;
      pinentryFlavor = "gnome3";
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
    programs.firefox = {
      enable = true;
#      profile = {
#        "leona".id = 0;
#        "uni".id = 1;
#      };
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
        "text/html" = [ "chromium.desktop" ];
        "x-scheme-handler/http" = [ "chromium.desktop" ];
        "x-scheme-handler/https" = [ "chromium.desktop" ];
        "x-scheme-handler/about" = [ "chromium.desktop" ];
        "x-scheme-handler/unknown" = [ "chromium.desktop" ];
        "image/avif" = [ "org.gnome.eog.desktop" ];
        "image/jpeg" = [ "org.gnome.eog.desktop" ];
        "image/png" = [ "org.gnome.eog.desktop" ];
        "image/svg+xml" = [ "org.gnome.eog.desktop" ];
        "application/pdf" = [ "org.gnome.Evince.desktop" ];
      };
    };
    services.nextcloud-client = {
      enable = true;
      startInBackground = true;
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
  networking.hosts = {
    "fd8f:d15b:9f40:101::1312" = [ "cloud.leona.is" ];
  };
}
