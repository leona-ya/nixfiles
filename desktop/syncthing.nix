{ lib, config, ... }:

{
  services.syncthing = {
    enable = true;
    openDefaultPorts = true;
    dataDir = lib.mkDefault "/home/em0lar/.syncthing";
    configDir = lib.mkDefault "${config.services.syncthing.dataDir}/conf";
    user = "em0lar";
    group = "users";
  };

  users.users.em0lar.extraGroups = [ "syncthing" ];
}
