{ config, lib, ... }:

{
  imports = [
    ./alacritty.nix
    ./applications.nix
    ./firefox.nix
    ./sound.nix
    ./syncthing.nix
    ./gammastep.nix
  ];
#  services.nginx.virtualHosts."${config.networking.hostName}.${config.networking.domain}" = {
#    enableACME = lib.mkForce false;
#    forceSSL = lib.mkForce false;
#  };
  time.timeZone = lib.mkForce "Europe/Berlin";
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
