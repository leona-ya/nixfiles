{ config, lib, pkgs, ... }:

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

    em0lar.secrets = {
      "backup_ssh_key".owner = "root";
      "backup_passphrase".owner = "root";
    };

    # prometheus borg exporter
    em0lar.telegraf.extraInputs = lib.mkIf config.em0lar.telegraf.enable {
      prometheus =  {
        urls = [ "http://127.0.0.1:7373" ];
      };
    };
    systemd.services.prometheus-borg-exporter = lib.mkIf config.em0lar.telegraf.enable {
      description = "Start Prometheus BorgBackup exporter";
      wantedBy = ["multi-user.target"];
      after = ["networking.target"];
      serviceConfig = {
        ExecStart = "${pkgs.prometheus-borg-exporter}/bin/prometheus-borg-exporter -s --sudo-command /run/wrappers/bin/sudo -l warn -c /run/current-system/sw/bin/borg-job-aido --failed-archive-suffix .failed";
        User = "prometheus-borg";
        StateDirectory = "prometheus-borg-exporter";
      };
    };
    users.users.prometheus-borg = lib.mkIf config.em0lar.telegraf.enable {
      description = "Prometheus Borg Exporter Service";
      group = "prometheus-borg";
      isSystemUser = true;
      createHome = true;
      home = "/var/lib/prometheus-borg-exporter";
    };
    users.groups.prometheus-borg = lib.mkIf config.em0lar.telegraf.enable {};
    security.sudo.extraRules = lib.mkIf config.em0lar.telegraf.enable [{
      users = [ "prometheus-borg" ];
      runAs = "root";
      commands = [
        {
          command = "/run/current-system/sw/bin/borg-job-aido info --json";
          options = [ "SETENV" "NOPASSWD" ];
        }
        {
          command = "/run/current-system/sw/bin/borg-job-aido list --json";
          options = [ "SETENV" "NOPASSWD" ];
        }
      ];
    }];
  };
}
