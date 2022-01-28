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
    citra
    element-desktop
    evince
    feh
    firefox-wayland
    gcc
    gh
    gimp
    gnome.eog
    gnome.gnome-bluetooth
    gnome.nautilus
    gnome.vinagre
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
    libreoffice-still
    nheko
    mitmproxy
    mpv
    mumble
    (wrapOBS {
      plugins = with obs-studio-plugins; [ wlrobs ];
    })
    obsidian
    openttd
    openssl
    pandoc
    pass-wayland
    postman
    python3
    rofi-pass 
    rustup
    sengi
    scribusUnstable
    signal-desktop
    speedcrunch
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
      iconTheme.name = "Qogir-dark";
      iconTheme.package = pkgs.qogir-icon-theme;
      theme = {
        name = "Qogir-dark";
        package = pkgs.qogir-theme;
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
        { id = "naepdomgkenhinolocfifgehidddafch"; } # browserpass
        # { id = "lckanjgmijmafbedllaakclkaicjfmnk"; } # clear urls
        # { id = "gdbofhhdmcladcmmfjolgndfkpobecpg"; } # don't track me google
     ];
    };
    programs.browserpass = {
      enable = true;
      browsers = [ "chromium" ];
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
      config.global.skip_dotenv = true;
    };

    xdg.mimeApps = {
      enable = true;
      defaultApplications = {
        "text/html" = [ "chromium-browser.desktop" ];
        "x-scheme-handler/http" = [ "chromium-browser.desktop" ];
        "x-scheme-handler/https" = [ "chromium-browser.desktop" ];
        "x-scheme-handler/about" = [ "chromium-browser.desktop" ];
        "x-scheme-handler/unknown" = [ "chromium-browser.desktop" ];
	      "x-scheme-handler/slack" = [ "slack.desktop" ];
        "image/avif" = [ "org.gnome.eog.desktop" ];
        "image/jpeg" = [ "org.gnome.eog.desktop" ];
        "image/png" = [ "org.gnome.eog.desktop" ];
        "image/svg+xml" = [ "org.gnome.eog.desktop" ];
      };
    };
  };
  environment.variables.SSH_AUTH_SOCK = "/run/user/1000/gnupg/S.gpg-agent.ssh";
  environment.variables.RUST_SRC_PATH = "${pkgs.rust.packages.stable.rustPlatform.rustLibSrc}";
  services.printing.enable = true;
}
