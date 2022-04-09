{ pkgs, config, ... }: {

  networking.hostName = "cole";
  networking.domain = "net.leona.is";
  services.resolved.dnssec = "false"; # dnssec check is already done on other dns server
  systemd.network = {
    links."10-eth0" = {
      matchConfig.MACAddress = "b8:27:eb:08:85:fa";
      linkConfig.Name = "eth0";
    };
    networks."10-eth0" = {
      DHCP = "yes";
      matchConfig = {
        Name = "eth0";
      };
    };
    links."10-wifi0" = {
      matchConfig.MACAddress = "b8:27:eb:5d:d0:af";
      linkConfig.Name = "wifi0";
    };
    networks."10-wifi0" = {
      DHCP = "yes";
      matchConfig = {
        Name = "wifi0";
      };
    };
  };

  nixpkgs.overlays = [
    (self: super: {
      firmwareLinuxNonfree = super.firmwareLinuxNonfree.overrideAttrs (old: {
        version = "2020-12-18";
        src = pkgs.fetchgit {
          url =
            "https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git";
          rev = "b79d2396bc630bfd9b4058459d3e82d7c3428599";
          sha256 = "1rb5b3fzxk5bi6kfqp76q1qszivi0v1kdz1cwj2llp5sd9ns03b5";
        };
        outputHash = "1p7vn2hfwca6w69jhw5zq70w44ji8mdnibm1z959aalax6ndy146";
      });
    })
  ];
  boot = {
    extraModprobeConfig = ''
      options cf680211 ieee80211_regdom="DE"
    '';
  };

  # wifi
  hardware.enableRedistributableFirmware = true;
  l.secrets = {
    "wifi/chaosthings.psk" = {};
  };
  networking.wireless.iwd.enable = true;
  systemd.services.iwd.serviceConfig = {
    Restart = "always";
    ExecStartPre = [
      "${pkgs.coreutils}/bin/ln -sf ${config.leona.secrets."wifi/chaosthings.psk".path} /var/lib/iwd/chaosthings.psk"
    ];
  };
}
