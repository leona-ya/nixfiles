{ config, lib, ... }:

let
  cfg = config.em0lar.backups;

  inherit (lib) mkEnableOption mkIf mkOption types;
in {
  options.em0lar.backups = {
    enable = mkEnableOption "em0lar backups";
    user = mkOption {
      type = types.str;
      default = "root";
    };
    group = mkOption {
      type = types.str;
      default = "root";
    };
    paths = mkOption {
      type = with types; listOf str;
      default = [ ];
    };
    excludes = mkOption {
      type = with types; listOf str;
      default = [
        "/nix"
        "/tmp"
        "/var/cache"
      ];
    };
    repo = mkOption {
      type = types.str;
    };
    encryptionMode = mkOption {
      type = types.str;
      default = "repokey-blake2";
    };
    encryptionPassCommand = mkOption {
      type = types.str;
    };
    sshPort = mkOption {
      type = types.str;
      default = "1880";
    };
    sshKeyFilePath = mkOption {
     type = types.str;
    };
    compression = mkOption {
      type = types.str;
      default = "auto,zstd";
    };
    enableSystemdTimer = mkOption {
      type = types.bool;
      default = true;
    };
    systemdTimerConfig = mkOption {
      type = types.attrs;
      default = {
        OnCalendar = "01:00";
        RandomizedDelaySec = 7200;
      };
    };
    pruneKeepConfig = mkOption {
      type = types.attrs;
      default = {
        within = "1d";
        daily = 7;
        weekly = 4;
        monthly = 12;
      };
    };
  };
  config = mkIf cfg.enable {
    services.borgbackup.jobs = {
      helene = {
        user = cfg.user;
        group = cfg.group;
        paths = cfg.paths;
        exclude = cfg.excludes;
        repo = cfg.repo;
        encryption = {
          mode = cfg.encryptionMode;
          passCommand = cfg.encryptionPassCommand;
        };
        environment = {
          BORG_RSH = "ssh -o StrictHostKeyChecking=no -p ${cfg.sshPort} -i ${cfg.sshKeyFilePath}";
        };
        compression = cfg.compression;
        prune.keep = cfg.pruneKeepConfig;
        doInit = true;
        startAt = [ ];
      };
    };
    systemd.timers.borgbackup-job-helene = lib.mkIf cfg.enableSystemdTimer {
      timerConfig = cfg.systemdTimerConfig;
      wantedBy = [ "timers.target" ];
    };
  };
}
