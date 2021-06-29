# inspired by petabyte (git.petabyte.dev/petabyteboy/nixfiles)
{ config, lib, pkgs, ... }:

with lib;

let
  secret-file = types.submodule ({ ... }@moduleAttrs: {
    options = {
      name = mkOption {
        type = types.str;
        default = moduleAttrs.config._module.args.name;
      };
      path = mkOption {
        type = types.str;
        readOnly = true;
        default = "/secrets/${removeSuffix ".gpg" (baseNameOf moduleAttrs.config.source-path)}";
      };
      mode = mkOption {
        type = types.str;
        default = "0400";
      };
      owner = mkOption {
        type = types.str;
        default = "root";
      };
      group-name = mkOption {
        type = types.str;
        default = "root";
      };
      source-path = mkOption {
        type = types.str;
        default = "${../../secrets + "/${config.networking.hostName}/${moduleAttrs.config.name}.gpg"}";
      };
      encrypted = mkOption {
        type = types.bool;
        default = true;
      };
      enable = mkOption {
        type = types.bool;
        default = true;
      };
    };
  });
  enabledFiles = filterAttrs (n: file: file.enable) config.em0lar.secrets;

  mkDecryptSecret = file: pkgs.writeScript "decrypt-secret-${removeSuffix ".gpg" (baseNameOf file.source-path)}.sh" ''
    #!${pkgs.runtimeShell}
    set -eu pipefail
    if [ ! -f "${file.path}" ]; then
      umask 0077
      echo "${file.source-path} -> ${file.path}"
      ${if file.encrypted then ''
        ${pkgs.gnupg}/bin/gpg --decrypt ${escapeShellArg file.source-path} > ${file.path}
      '' else ''
        cat ${escapeShellArg file.source-path} > ${file.path}
      ''}
    fi
  '';
  mkSetupSecret = file: pkgs.writeScript "setup-secret-${removeSuffix ".gpg" (baseNameOf file.source-path)}.sh" ''
    #!${pkgs.runtimeShell}
    set -eu pipefail
    chown ${escapeShellArg file.owner}:${escapeShellArg file.group-name} ${escapeShellArg file.path}
    chmod ${escapeShellArg file.mode} ${escapeShellArg file.path}
  '';


in {
  options.em0lar.secrets = mkOption {
    type = with types; attrsOf secret-file;
    default = { };
  };
  config = mkIf (enabledFiles != { }) {
    system.activationScripts = let
      files = unique (map (flip removeAttrs ["_module"]) (attrValues enabledFiles));
      decrypt = ''
        function fail() {
          rm $1
          echo "failed to decrypt $1"
        }
        echo decrypting up secrets...
        mkdir -p /secrets
        mountpoint -q /secrets || mount -t tmpfs -o size=50m tmpfs /secrets
        chown 0:0 /secrets
        chmod 0755 /secrets
        ${concatMapStringsSep "\n" (file: ''
          ${mkDecryptSecret file} || fail ${file.path}
        '') files}
      '';
      setup = ''
        echo setting up secrets...
        ${concatMapStringsSep "\n" (file: ''
          ${mkSetupSecret file} || echo "failed to set up ${file.path}"
        '') files}
      '';
    in {
      decrypt-secrets.text = "source ${pkgs.writeText "decrypt-secrets.sh" decrypt}";
      setup-secrets = stringAfter [ "users" "groups" ] "source ${pkgs.writeText "setup-secrets.sh" setup}";
      users.deps = [ "decrypt-secrets" ];
    };
  };
}
