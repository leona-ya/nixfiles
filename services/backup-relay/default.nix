{ config, pkgs, ... }:

{
  l.sops.secrets = {
    "services/backup-relay/backup_cifs_credentials" = {};
  };
  fileSystems = {
    "/mnt/backup" = {
      device = "//10.151.1.1/backup/borg";
      fsType = "cifs";
      options = ["_netdev,credentials=${config.sops.secrets."services/backup-relay/backup_cifs_credentials".path},uid=${toString config.users.users.borg.uid}" ]; #uid=null
    };
  };
  services.borgbackup.repos = {
    beryl = {
      path = "/mnt/backup/repos/synced/beryl.net.leona.is";
      authorizedKeys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICa5+iHHAzn+5k/u3Y8frtoTTK1tYKo8YTRJzOVxaMdj backup@beryl" ];
    };
    foros = {
      path = "/mnt/backup/repos/synced/foros.net.leona.is";
      authorizedKeys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAJburzi+OgeUAZ5EHcW0vU+Cuj7nSm6sLn/CWeLuhJv backup@foros" ];
    };
    haku = {
      path = "/mnt/backup/repos/synced/haku.net.leona.is";
      authorizedKeys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDXunkOUc3sHoqk9nF9itU8YTz1D+ruvzxndDMdrKDia backup@haku" ];
    };
    kupe = {
      path = "/mnt/backup/repos/synced/kupe.net.leona.is";
      authorizedKeys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOZipH7+NS8bpRxcmOPdijI4Q+5fiX3TWPgDHz0G7lSE backup@kupe" ];
    };
    ladon = {
      path = "/mnt/backup/repos/synced/ladon.net.leona.is";
      authorizedKeys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINkp8EVZ43eeenJlOGVciMkulk5LByQQ9gK3alZdQbeY backup@ladon" ];
    };
    naiad = {
      path = "/mnt/backup/repos/synced/naiad.net.leona.is";
      authorizedKeys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL8lo78J22v9FIAMJKad+6KpCTqrYmHrjiWoZYlYN7fP backup@naiad" ];
    };
    turingmachine = {
      path = "/mnt/backup/repos/synced/turingmachine.net.leona.is";
      authorizedKeys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIhL7xVXxcTN6qX/trg6IoH4dftCnkZ/RRIii/5KNpIV turingmachine" ];
    };
    utopia = {
      path = "/mnt/backup/repos/synced/utopia.net.leona.is";
      authorizedKeys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKPpGg5QF9jJAKPdQEGNulcwctxHY/U+VaZV4322XyfB backup@utopia" ];
    };
  };
  users.users.borg.uid = 997;
}
