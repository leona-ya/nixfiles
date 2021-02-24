{ config, lib, ... }:

{
  services.borgbackup.jobs = {
    helene = {
      paths = backups.options.paths;
      doInit = true;
      repo = "backup@helene.int.sig.de.em0lar.dev:/mnt/backups/repos/synced/${config.networking.hostName}.${config.networking.domain}";
      encryption = {
        mode = lib.mkDefault "repokey-blake2";
        passCommand = "cat ${config.em0lar.secrets."borgbackup_encryption_passphrase".path}";
      };
      environment = {
        BORG_RSH = "ssh -o StrictHostKeyChecking=no -p 1880 -i ${config.em0lar.secrets."borgbackup_ssh_private_key".path}";
      };
      compression = lib.mkDefault "auto,zstd";
    };
  };
}
