{ config, lib, ... }:

{
  imports = [
    ./sway
    ./i3-minimal
    ./alacritty.nix
    ./applications.nix
    ./sound.nix
    ./syncthing.nix
  ];
  services.nginx.virtualHosts."${config.networking.hostName}.${config.networking.domain}" = {
    enableACME = lib.mkForce false;
    forceSSL = lib.mkForce false;
  };
  time.timeZone = "Europe/Berlin";
  services.openssh.settings = {
    StreamLocalBindUnlink = true;
  };
  services.zfs = lib.mkIf (lib.elem "zfs" config.boot.supportedFilesystems) {
    autoScrub.enable = true;
    autoSnapshot = {
      enable = true;
      frequent = 12;
      hourly = 24;
      daily = 7;
      weekly = 0;
      monthly = 0;
    };
  };
}
