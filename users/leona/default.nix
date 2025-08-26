{
  pkgs,
  lib,
  config,
  ...
}:

let
  setPassword = !config.l.meta.bootstrap && config.nixpkgs.hostPlatform.isLinux;
in {
  imports = [
    ./importable.nix
  ];
  config = lib.mkIf setPassword {
    l.sops.secrets."all/users/leona_pw" = {
      neededForUsers = true;
    };
    users.users.leona.hashedPasswordFile = (
      lib.mkDefault config.sops.secrets."all/users/leona_pw".path
    );
  };
}
