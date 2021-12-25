{ lib, pkgs, config, ... }:

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
    meslo-lgs-nf
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
    _1password-gui
    ansible_2_9
    chromium
    citra
    element-desktop
    evince
    (firefox-wayland.override { extraNativeMessagingHosts = [ passff-host ]; })
    gcc
    gh
    gimp
    gnome3.vinagre
    hamster
    homebank
    inkscape
    (jetbrains.jetbrains-client.override {
      jdk = jetbrains.jdk;
    })
    (jetbrains.datagrip.override {
      jdk = jetbrains.jdk;
    })
    (jetbrains.idea-community.override {
    	jdk = jetbrains.jdk;
    })
    (jetbrains.idea-ultimate.override {
      jdk = jetbrains.jdk;
    })
    libreoffice-fresh
    nheko
    mitmproxy
    mpv
    mumble
    (wrapOBS {
      plugins = with obs-studio-plugins; [ wlrobs ];
    })
    openttd
    openssl
    pandoc
    pass-wayland
    postman
    python3
    rofi-pass 
    rustup
    sengi
    signal-desktop
    spotify
    sublime4
    superTuxKart
    texlive.combined.scheme-full
    thunderbird-wayland
    virt-manager
    youtube-dl
    z-lua
  ] ++ [
    nodejs-16_x
    sbt
    slack
    (zoom-us.overrideAttrs (old: {
      postFixup = old.postFixup + ''
        wrapProgram $out/bin/zoom --unset XDG_SESSION_TYPE --set QT_QPA_PLATFORM xcb
      '';}))
  ];

  boot.extraModulePackages = [ config.boot.kernelPackages.v4l2loopback ];
  boot.kernelModules = [
    "v4l2loopback"
  ];
  boot.extraModprobeConfig = ''
    options v4l2loopback devices=2 exclusive_caps=1
  '';

  services.fwupd.enable = true;

  services.udev.packages = [ pkgs.yubikey-personalization ];
  environment.variables.MOZ_USE_XINPUT2 = "1"; # for firefox
  hardware.bluetooth.enable = true;

  virtualisation.docker = {
    enable = true;
    enableOnBoot = false;
  };
  em0lar.nftables.generateDockerRules = true;
  programs.java.enable = true;
  services.gnome.gnome-keyring.enable = true;
  programs.seahorse.enable = true;

  home-manager.users.em0lar = {
    xdg.enable = true;
    gtk = {
      enable = true;
      iconTheme.name = "Adwaita";
      iconTheme.package = pkgs.gnome3.adwaita-icon-theme;
      theme = {
        name = "Adawaita-dark";
        package = pkgs.gnome.gnome_themes_standard;
      };
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
      sshKeys = [
        "8AB64FC46268F8634C86BA3F52B5C315E98D38C4"
	      "D91C5A1E23D3EE4DC72A5BEF0EA93C9F634A79F5"
      ];
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
        eval "$(direnv hook zsh)"
      '';
      shellAliases = {
        "pdev" = "pandoc --template eisvogel --listings";
      };
    };
    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    xdg.mimeApps = {
      enable = true;
      defaultApplications = {
        "text/html" = [ "org.qutebrowser.qutebrowser.desktop" ];
        "x-scheme-handler/http" = [ "org.qutebrowser.qutebrowser.desktop" ];
        "x-scheme-handler/https" = [ "org.qutebrowser.qutebrowser.desktop" ];
        "x-scheme-handler/about" = [ "org.qutebrowser.qutebrowser.desktop" ];
        "x-scheme-handler/unknown" = [ "org.qutebrowser.qutebrowser.desktop" ];
	      "x-scheme-handler/slack" = [ "slack.desktop" ];
      };
    };
  };
  environment.variables.SSH_AUTH_SOCK = "/run/user/1000/gnupg/S.gpg-agent.ssh";
  environment.variables.RUST_SRC_PATH = "${pkgs.rust.packages.stable.rustPlatform.rustLibSrc}";
  services.printing.enable = true;
}
