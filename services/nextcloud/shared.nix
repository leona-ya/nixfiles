{ pkgs, config, ... }:
{
  em0lar.secrets."cloud-shared-sync-ssh".owner = "root";
  systemd.timers.cloud-shared-sync = {
    timerConfig = {
      OnCalendar = "*:0/15";
    };
    wantedBy = [ "timers.target" ];
  };
  systemd.services.cloud-shared-sync = {
    description = "cloud-shared-sync";
    script = ''
      size_old="$(${pkgs.coreutils}/bin/cat /var/lib/nextcloud/data/leo/files/Bilder/2021_10-Saalbach/Saalbach-Sammlung/.SIZE)"
      size_new="$(${pkgs.coreutils}/bin/du -s /var/lib/nextcloud/data/leo/files/Bilder/2021_10-Saalbach/Saalbach-Sammlung | ${pkgs.gawk}/bin/awk '{print$1}')"
      if [[ $size_old != $size_new ]]
      then
        ${pkgs.rsync}/bin/rsync -e "${pkgs.openssh}/bin/ssh -i ${config.em0lar.secrets.cloud-shared-sync-ssh.path} -p 61337" -a /var/lib/nextcloud/data/leo/files/Bilder/2021_10-Saalbach/Saalbach-Sammlung/ cloudsharedsync@haku.net.em0lar.dev:/var/lib/nextcloud-shared/Saalbach-Sammlung
        echo "$size_new" > /var/lib/nextcloud/data/leo/files/Bilder/2021_10-Saalbach/Saalbach-Sammlung/.SIZE
      fi
    '';
  };
}
