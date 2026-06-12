{
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    ../../profiles/moka-libvirt
    ./network.nix
    inputs.disko.nixosModules.disko
    ./disko.nix
    #../../services/staging/discourse
    #../../services/staging/keycloak
  ];

  users.users.test = {
    home = "/home/test";
    group = "test";
    isNormalUser = true;
  };
  users.groups.test = { };

  services.postgresql.package = pkgs.postgresql_18;
  services.mysql.enable = true;
  services.mysql.package = pkgs.mysql84;
  services.mysql.ensureDatabases = [ "test" ];
  services.mysql.ensureUsers = [
    {
      name = "leona";
      ensurePermissions = {
        "test.*" = "ALL PRIVILEGES";
      };
    }
  ];

  system.stateVersion = "26.05";
}
