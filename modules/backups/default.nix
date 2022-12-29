{ config, lib, pkgs, ... }:

let
  cfg = config.l.backups;

  inherit (lib) mkEnableOption mkIf mkOption types;
in {
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
        "/persist"
        "/root"
      ];
    };

    excludes = mkOption {
      type = with types; listOf str;
      default = [ ];
    };
    repo = mkOption {
      type = types.str;
      default = "b2:leona-nix-backup:${config.networking.hostName}";
    };
    enableSystemdTimer = mkOption {
      type = types.bool;
      default = true;
    };
    systemdTimerConfig = mkOption {
      type = types.attrs;
      default = {
        OnCalendar = "01:00";
        RandomizedDelaySec = "4h";
      };
    };
    pruneOpts = mkOption {
      type = types.listOf types.str;
      default = [
        "--keep-daily 7"
        "--keep-weekly 4"
        "--keep-monthly 12"
        "--keep-yearly 2"
      ];
    };
  };
  config = mkIf cfg.enable {
    l.sops.secrets = {
      "hosts/${config.networking.hostName}/restic_password" = {};
      "hosts/${config.networking.hostName}/restic_env" = {};
    };

    services.restic.backups = {
      b2-remote = {
        user = cfg.user;
        environmentFile = config.sops.secrets."hosts/${config.networking.hostName}/restic_env".path;
        passwordFile = config.sops.secrets."hosts/${config.networking.hostName}/restic_password".path;
        paths = cfg.paths;
        repository = cfg.repo;
        timerConfig = cfg.systemdTimerConfig;
        initialize = true;
        backupPrepareCommand = mkIf config.services.postgresql.enable ''
          mkdir -p /var/lib/restic-backup
          ${pkgs.sudo}/bin/sudo -u postgres ${pkgs.postgresql}/bin/pg_dumpall | ${pkgs.zstd}/bin/zstd --rsyncable > /var/lib/restic-backup/restic-postgres.sql.zst
        '';
        backupCleanupCommand = mkIf config.services.postgresql.enable ''
          rm -rf /var/lib/restic-backup
        '';
        pruneOpts = cfg.pruneOpts;
        # todo: excludes
      };
    };
  };
}
