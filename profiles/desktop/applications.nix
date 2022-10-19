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
    wl-clipboard
    xdg-utils
  ];
  programs.nix-ld.enable = true;

  users.users.leona.packages = with pkgs; [
    arduino
    bitwarden
    element-desktop
    evince
    feh
    gcc11
    gimp
    gnome.eog
    gnome.gnome-bluetooth
    gnome.nautilus
    gnome.vinagre
    homebank
    cmake
    gnumake
    (jetbrains.clion.override {
      jdk = jetbrains.jdk;
    })
    (jetbrains.idea-ultimate.override {
      jdk = jetbrains.jdk;
    })
    #kicad
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
    python3
    rofi-pass
    rustup
    sengi
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
    (zoom-us.overrideAttrs (old: {
      postFixup = old.postFixup + ''
        wrapProgram $out/bin/zoom --unset XDG_SESSION_TYPE --set QT_QPA_PLATFORM xcb
      '';
    }))
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
  virtualisation.spiceUSBRedirection.enable = true;
  virtualisation.docker = {
    enable = true;
    enableOnBoot = false;
    daemon.settings = {
      bip = "172.37.0.1/16";
      default-address-pools = [
        {
	  base = "10.38.0.0/16";
	  size = 24;
	}
      ];
    };
  };
  l.nftables.generateDockerRules = true;
  programs.java.enable = true;
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
	      "D91C5A1E23D3EE4DC72A5BEF0EA93C9F634A79F5" # cc
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
        { id = "nngceckbapebfimnlniiiahkandclblb"; } # bitwarden
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
      config.global.load_dotenv = false;
    };

    xdg.configFile."mimeapps.list".force = true;
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
        "application/pdf" = [ "org.gnome.Evince.desktop" ];
      };
    };
  };
  environment.variables.SSH_AUTH_SOCK = "/run/user/1000/gnupg/S.gpg-agent.ssh";
  environment.variables.RUST_SRC_PATH = "${pkgs.rust.packages.stable.rustPlatform.rustLibSrc}";
  services.printing = {
    enable = true;
    drivers = [  pkgs.cups-toshiba-estudio ];
  };
  programs.steam.enable = true;
}
