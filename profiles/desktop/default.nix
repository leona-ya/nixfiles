{ config, lib, inputs, ... }:

{
  imports = [
    #inputs.lix-module.nixosModules.default
    ./wezterm.nix
    ./applications.nix
    ./firefox.nix
    ./sound.nix
    ./syncthing.nix
    ./gammastep.nix
    ./uni-vpn.nix
    ./darkman.nix
  ];
  nix.settings.experimental-features = [ "pipe-operators" ];

  security.pam.services.login.fprintAuth = lib.mkForce false;
  services.nginx.virtualHosts."${config.networking.hostName}.${config.networking.domain}" = {
    enableACME = lib.mkOverride 96 false;
    forceSSL = lib.mkOverride 96 false;
  };
  time.timeZone = lib.mkForce "Europe/Berlin";
  services.openssh.settings = {
    StreamLocalBindUnlink = true;
  };
  documentation.dev.enable = true;
  services.logind.lidSwitch = "suspend-then-hibernate";
  services.logind.powerKey = "hibernate";
  services.logind.powerKeyLongPress = "poweroff";
  services.power-profiles-daemon.enable = true;
  services.zfs = lib.mkIf (config.boot.supportedFilesystems.zfs or false) {
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
