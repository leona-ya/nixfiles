{ lib, config, ... }:

{
  services.syncthing = {
    enable = true;
    openDefaultPorts = true;
    dataDir = lib.mkDefault "/home/leona/.syncthing";
    configDir = lib.mkDefault "${config.services.syncthing.dataDir}/conf";
    user = "leona";
    group = "users";
  };

  users.users.leona.extraGroups = [ "syncthing" ];
}
