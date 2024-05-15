{ pkgs, lib, config, ... }:

{
  imports = [
    ./importable.nix
  ];
  l.sops.secrets."all/users/leona_pw".neededForUsers = true;
  users.users.leona.hashedPasswordFile = lib.mkDefault config.sops.secrets."all/users/leona_pw".path;
}

