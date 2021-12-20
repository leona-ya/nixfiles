{ config, pkgs, ... }:

{
  em0lar.sops.secrets = {
    "services/backup-relay/backup_cifs_credentials" = {};
    "services/backup-relay/b2_rclone_conf" = {};
  };
  fileSystems = {
    "/mnt/backup" = {
      device = "//encladus.lan/backup/borg";
      fsType = "cifs";
      options = ["_netdev,credentials=${config.sops.secrets."services/backup-relay/backup_cifs_credentials".path},uid=${toString config.users.users.borg.uid}" ]; #uid=null
    };
  };
  services.borgbackup.repos = {
    beryl = {
      path = "/mnt/backup/repos/synced/beryl.net.em0lar.dev";
      authorizedKeys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICa5+iHHAzn+5k/u3Y8frtoTTK1tYKo8YTRJzOVxaMdj backup@beryl" ];
    };
    foros = {
      path = "/mnt/backup/repos/synced/foros.net.em0lar.dev";
      authorizedKeys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAJburzi+OgeUAZ5EHcW0vU+Cuj7nSm6sLn/CWeLuhJv backup@foros" ];
    };
    haku = {
      path = "/mnt/backup/repos/synced/haku.net.em0lar.dev";
      authorizedKeys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDXunkOUc3sHoqk9nF9itU8YTz1D+ruvzxndDMdrKDia backup@haku" ];
    };
    kupe = {
      path = "/mnt/backup/repos/synced/kupe.net.em0lar.dev";
      authorizedKeys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOZipH7+NS8bpRxcmOPdijI4Q+5fiX3TWPgDHz0G7lSE backup@kupe" ];
    };
    ladon = {
      path = "/mnt/backup/repos/synced/ladon.net.em0lar.dev";
      authorizedKeys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINkp8EVZ43eeenJlOGVciMkulk5LByQQ9gK3alZdQbeY backup@ladon" ];
    };
    naiad = {
      path = "/mnt/backup/repos/synced/naiad.net.em0lar.dev";
      authorizedKeys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL8lo78J22v9FIAMJKad+6KpCTqrYmHrjiWoZYlYN7fP backup@naiad" ];
    };
    turingmachine = {
      path = "/mnt/backup/repos/synced/turingmachine.net.em0lar.dev";
      authorizedKeys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIhL7xVXxcTN6qX/trg6IoH4dftCnkZ/RRIii/5KNpIV em0lar@turingmachine" ];
    };
    utopia = {
      path = "/mnt/backup/repos/synced/utopia.net.em0lar.dev";
      authorizedKeys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKPpGg5QF9jJAKPdQEGNulcwctxHY/U+VaZV4322XyfB backup@utopia" ];
    };
  };
  users.users.borg.uid = 997;
  systemd.services.b2-backup-sync = {
    description = "B2 Backup sync";
    script = ''
      ${pkgs.rclone}/bin/rclone --config ${config.sops.secrets."services/backup-relay/b2_rclone_conf".path} sync /mnt/backup/repos/synced b2:labcode-backup
      ${pkgs.rclone}/bin/rclone --config ${config.sops.secrets."services/backup-relay/b2_rclone_conf".path} cleanup b2:labcode-backup
    '';
  };
  systemd.timers.b2-backup-sync = {
    timerConfig = {
      OnCalendar = "Sat *-*-* 04:00:00";
      RandomizedDelaySec = 1200;
    };
    wantedBy = [ "timers.target" ];
  };
}
