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
      default = [
        "/home"
        "/var"
        "/etc"
        "/root"
      ];
    };
    excludes = mkOption {
      type = with types; listOf str;
      default = [
        "/var/cache"
        "/var/lock"
        "/var/spool"
        "/var/log"
      ];
    };
    repo = mkOption {
      type = types.str;
      default = "ssh://borg@[fd8f:d15b:9f40:11:982d:6eff:fefc:10a2]:61337/mnt/backup/repos/synced/${config.networking.hostName}.${config.networking.domain}";
    };
    encryptionMode = mkOption {
      type = types.str;
      default = "repokey-blake2";
    };
    encryptionPassCommand = mkOption {
      type = types.str;
      default = "cat ${config.em0lar.secrets.backup_passphrase.path}";
    };
    sshKeyFilePath = mkOption {
     type = types.str;
     default = "${config.em0lar.secrets.backup_ssh_key.path}";
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
      aido = {
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
          BORG_RSH = "ssh -o StrictHostKeyChecking=no -i ${cfg.sshKeyFilePath} -p 61337";
          BORG_RELOCATED_REPO_ACCESS_IS_OK = "yes";
        };
        compression = cfg.compression;
        prune.keep = cfg.pruneKeepConfig;
        prune.prefix = "";
        doInit = true;
        startAt = [ ];
      };
    };
    systemd.timers.borgbackup-job-aido = lib.mkIf cfg.enableSystemdTimer {
      timerConfig = cfg.systemdTimerConfig;
      wantedBy = [ "timers.target" ];
    };
  };
}
