{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.l.backups;

  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    types
    ;
in
{
  options.l.backups = {
    enable = mkEnableOption "leona backups";
    user = mkOption {
      type = types.str;
      default = "root";
    };
    paths = mkOption {
      type = with types; listOf str;
      default = [
        "/home"
        "/var/lib"
        "/persist"
        "/root"
      ];
    };

    excludes = mkOption {
      type = with types; listOf str;
      default = [ ];
    };
    enableSystemdTimer = mkOption {
      type = types.bool;
      default = true;
    };
    systemdTimerConfig = mkOption {
      type = types.attrs;
      default = {
        OnCalendar = "hourly";
        RandomizedDelaySec = "30min";
        FixedRandomDelay = true;
      };
    };
    pruneOpts = mkOption {
      type = types.listOf types.str;
      default = [
        "--keep-last 24"
        "--keep-daily 7"
        "--keep-weekly 4"
        "--keep-monthly 12"
      ];
    };
  };
  config = mkIf cfg.enable {
    l.sops.secrets = {
      "hosts/${config.networking.hostName}/restic_password" = { };
      "hosts/${config.networking.hostName}/restic_env" = { };
      "hosts/${config.networking.hostName}/restic_repository" = { };
    };

    services.restic.backups = {
      "ovh-remote" = {
        inherit (cfg) user paths pruneOpts;
        environmentFile = config.sops.secrets."hosts/${config.networking.hostName}/restic_env".path;
        passwordFile = config.sops.secrets."hosts/${config.networking.hostName}/restic_password".path;
        repositoryFile = config.sops.secrets."hosts/${config.networking.hostName}/restic_repository".path;
        timerConfig = if cfg.enableSystemdTimer then cfg.systemdTimerConfig else null;
        initialize = true;
        backupPrepareCommand = mkIf config.services.postgresql.enable ''
          mkdir -p /root/restic-backup
          ${pkgs.sudo}/bin/sudo -u postgres ${config.services.postgresql.finalPackage}/bin/pg_dumpall | ${pkgs.zstd}/bin/zstd --rsyncable > /root/restic-backup/restic-postgres.sql.zst
        '';
        backupCleanupCommand = mkIf config.services.postgresql.enable ''
          rm -rf /root/restic-backup
        '';
        extraBackupArgs = lib.mkIf (cfg.excludes != [ ]) (
          builtins.map (x: "--exclude \"" + x + "\"") cfg.excludes
        );
      };
    };
  };
}
