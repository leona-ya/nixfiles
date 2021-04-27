{ config, lib, ... }:

{
  imports = [
    ./wm
    ./applications.nix
    ./sound.nix
    ./syncthing.nix
    #./zsh.nix
  ];
  services.nginx.virtualHosts."${config.networking.hostName}.${config.networking.domain}" = {
    enableACME = lib.mkForce false;
    forceSSL = lib.mkForce false;
  };
}
