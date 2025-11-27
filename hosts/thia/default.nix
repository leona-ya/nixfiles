{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    inputs.disko.nixosModules.disko
    ./hardware-configuration.nix
    ./hw.nix
    ../../profiles/desktop/syncthing.nix
    ../../services/int-acme-ca
    ../../services/paperless
    ../../services/bn-smarthome
    ../../services/youtrack
    ../../services/nextcloud
    ../../services/actual-budget
    ./disko.nix
    ./network.nix
    ./libvirt.nix
    ./kanshi.nix
  ];

  deployment.allowLocalDeployment = true;
  deployment.targetHost = "thia.wg.net.leona.is";
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.editor = false;
  boot.loader.efi.canTouchEfiVariables = true;
  l.remote-unlock.enable = true;
  
  zramSwap.enable = false;
  networking.hostId = "d5714cb9";
  nix.distributedBuilds = false;
  services.nginx.defaultListenAddresses = [
    "0.0.0.0"
    "[::1]"
    "[fd8f:d15b:9f40:101::1312]"
  ];

  l.backups = {
    enable = true;
    paths = [
      "/home"
      "/root"
      "/var/lib/paperless"
      "/var/lib/hass"
      "/var/lib/youtrack"
      "/var/lib/nextcloud"
    ];
    excludes = [
      "/var/cache"
      "/var/lock"
      "/var/spool"
      "/var/log"
      "/home/leona/.local/share/containers"
      "/var/lib/containers"
      "/home/leona/nextcloud"
      "**/node_modules"
      "**/.venv"
      "**/target"
      "/home/*/.cache"
      "/home/*/.rustup"
      "/home/*/.local/share/Steam"
      "/home/*/.m2"
      "/home/*/tmp"
      "**/Cache"
    ];
    enableSystemdTimer = false;
  };

  services.nginx.virtualHosts."thia.net.leona.is" = {
    forceSSL = lib.mkForce true;
  };
  security.acme.certs."thia.net.leona.is".server = "https://acme.int.leona.is/acme/acme/directory";

  system.stateVersion = "23.05";
}
