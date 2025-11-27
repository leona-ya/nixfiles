{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.l.sops;
  effectiveSecrets =
    lib.filterAttrs (_: value: (value.enable or true)) cfg.secrets
    |> builtins.mapAttrs (_: value: builtins.removeAttrs value [ "enable" ]);
in
{
  options.l.sops = with lib; {
    secrets = mkOption {
      type = types.attrs;
      default = { };
    };
  };
  config = {
    sops.secrets = lib.mapAttrs (
      name: value:
      let
        name_split = lib.splitString "/" name;
      in
      {
        sopsFile = ../../secrets/${builtins.elemAt name_split 0}/${builtins.elemAt name_split 1}.yaml;
      }
      // value
    ) effectiveSecrets;
  };
}
