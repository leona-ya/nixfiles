{ lib, pkgs, ... }:

{
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
  ];

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    libusb-compat-0_1
    lm_sensors
    pinentry
    pinentry-qt
    wl-clipboard
    xdg_utils
  ];

  users.users.em0lar.packages = with pkgs; [
    ansible_2_9
    chromium
    element-desktop-wayland
    evince
    (firefox-wayland.override { extraNativeMessagingHosts = [ passff-host ]; })
    gcc
    gh
    gimp
    gnome3.vinagre
    hamster
    inkscape
    (jetbrains.datagrip.override {
      jdk = jetbrains.jdk;
    })
    (jetbrains.idea-ultimate.override {
      jdk = jetbrains.jdk;
    })
    libreoffice-fresh
    mpv
    mumble
    openttd
    pandoc
    pass-wayland
    postman
    python3
    rofi-pass 
    rustup
    sengi
    spotify
    superTuxKart
    texlive.combined.scheme-full
    thunderbird-wayland
    youtube-dl
    z-lua
  ];
  services.fwupd.enable = true;

  services.udev.packages = [ pkgs.yubikey-personalization ];
  environment.variables.MOZ_USE_XINPUT2 = "1"; # for firefox
  hardware.bluetooth.enable = true;

  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
  };

  home-manager.users.em0lar = {
    xdg.enable = true;
    gtk = {
      enable = true;
      iconTheme.name = "Adwaita";
      iconTheme.package = pkgs.gnome3.adwaita-icon-theme;

      gtk3 = {
        extraConfig = {
          gtk-application-prefer-dark-theme = true;
        };
      };
    };
    programs.gpg.enable = true;
    services.gpg-agent = {
      enable = true;
      enableSshSupport = true;
      pinentryFlavor = "qt";
      enableExtraSocket = true;
      sshKeys = [ "430411806903447FF65FCBCBB1ADA545CD2CBACD" ];
    };
    programs.qutebrowser = {
      enable = true;
      keyBindings.normal = {
        "<z><l>" = "spawn --userscript qute-pass --username-target secret --username-pattern \"username|user: (.+)\"";
        "<z><u><l>" = "spawn --userscript qute-pass --username-only --username-target secret --username-pattern \"username|user: (.+)\"";
        "<z><p><l>" = "spawn --userscript qute-pass --password-only";
        "J" = "tab-prev";
        "K" = "tab-next";
      };
      settings = {
        auto_save.session = true;
        colors.webpage.preferred_color_scheme = "dark";
      };
      extraConfig = ''
        c.qt.args.append('widevine-path=${pkgs.widevine-cdm}/lib/libwidevinecdm.so')
      '';
    };
    programs.password-store.enable = true;
    programs.zsh = {
      initExtra = ''
        eval "$(${pkgs.z-lua}/bin/z --init zsh)"
      '';
      shellAliases = {
        "pdev" = "pandoc --template eisvogel --listings";
      };
    };
    xdg.mimeApps = {
      enable = true;
      defaultApplications = {
        "text/html" = [ "org.qutebrowser.qutebrowser.desktop" ];
        "x-scheme-handler/http" = [ "org.qutebrowser.qutebrowser.desktop" ];
        "x-scheme-handler/https" = [ "org.qutebrowser.qutebrowser.desktop" ];
        "x-scheme-handler/about" = [ "org.qutebrowser.qutebrowser.desktop" ];
        "x-scheme-handler/unknown" = [ "org.qutebrowser.qutebrowser.desktop" ];
      };
    };
  };
  environment.variables.SSH_AUTH_SOCK = "/run/user/1000/gnupg/S.gpg-agent.ssh";
  environment.variables.RUST_SRC_PATH = "${pkgs.rust.packages.stable.rustPlatform.rustLibSrc}";
  services.printing.enable = true;
}
