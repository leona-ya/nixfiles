{ pkgs, lib, config, ... }:
let
  cfg = config.em0lar.sops;
in {
  options.em0lar.sops = with lib; {
    secrets = mkOption {
      type = types.attrs;
      default = {};
    };
  };
  config = {
    sops.secrets = lib.mapAttrs (name: value: let
      name_split = lib.splitString "/" name;
    in {
      sopsFile = ../../secrets/${builtins.elemAt name_split 0}/${builtins.elemAt name_split 1}.yaml;
    } // value) cfg.secrets;
  };
}
