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
    element-desktop
    evince
    (firefox-wayland.override { extraNativeMessagingHosts = [ passff-host ]; })
    gimp
    gnome3.vinagre
    hamster
    inkscape
    jetbrains.datagrip
    jetbrains.idea-ultimate
    libreoffice-fresh
    mpv
    mumble
    pandoc
    pass-wayland
    postman
    python3
    rofi-pass
    spotify
    texlive.combined.scheme-medium
    thunderbird
    youtube-dl
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
