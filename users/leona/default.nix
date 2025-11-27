{
  pkgs,
  lib,
  config,
  ...
}:

{
  imports = [
    ./importable.nix
  ];
  l.sops.secrets."all/users/leona_pw" = {
    enable = !config.l.meta.bootstrap;
    neededForUsers = true;
  };
  users.users.leona.hashedPasswordFile = lib.mkIf (!config.l.meta.bootstrap) (
    lib.mkDefault config.sops.secrets."all/users/leona_pw".path
  );
}
