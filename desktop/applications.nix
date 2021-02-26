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
    pinentry
    pinentry-qt
    xdg_utils
    libusb-compat-0_1
    wl-clipboard
    lm_sensors
  ];

  users.users.em0lar.packages = with pkgs; [
    (firefox-wayland.override { extraNativeMessagingHosts = [ passff-host ]; })
    jetbrains.idea-ultimate
    jetbrains.datagrip
    python3
    pass-wayland
    rofi-pass
    gimp
    thunderbird
    spotify
    mpv
    youtube-dl
    evince
    hamster
    chromium
    (ferdi.overrideAttrs (oldAttrs: rec {
      version = "5.6.0-beta.5";
      name = "${oldAttrs.pname}-${version}";
      src = pkgs.fetchurl {
        url = "https://github.com/getferdi/ferdi/releases/download/v${version}/ferdi_${version}_amd64.deb";
        sha256 = "0x26hnszgq9pn76j1q9zklagwq5hyip7hgca7cvy9p7r59i36dbw";
      };
    }))
    teams # school, grr
    texlive.combined.scheme-medium
    gnome3.vinagre
    mumble
    libreoffice-fresh
    inkscape
    pandoc
    ansible_2_9
    z-lua
  ];

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
    programs.password-store.enable = true;
    programs.zsh.initExtra = ''
      eval "$(${pkgs.z-lua}/bin/z --init zsh)"
    '';
  };
  environment.variables.SSH_AUTH_SOCK = "/run/user/1000/gnupg/S.gpg-agent.ssh";
}
