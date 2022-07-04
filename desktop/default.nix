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
}
