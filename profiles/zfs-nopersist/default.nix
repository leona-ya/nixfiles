{ config, lib, pkgs, ... }:

with lib;

let
  bindmount-paths = listToAttrs (map (service:
    nameValuePair "/var/lib/${service}" "/persist/var/lib/${service}")
     (builtins.filter (service: config.services."${service}".enable) [
      "pleroma"
      "opendkim"
      "rspamd"
      "postfix"
      "openldap"
      "vikunja"
      "matrix-synapse"
      "knot"
    ])) // (if config.services.opendkim.enable then { "/var/dkim" = "/persist/var/dkim"; } else { })
       // (if config.services.dovecot2.enable then { "/var/lib/dovecot" = "/persist/var/lib/dovecot"; "/var/sieve" = "/persist/var/sieve"; "/var/vmail" = "/persist/var/vmail"; } else { })
       // (if config.services.vaultwarden.enable then { "/var/lib/bitwarden_rs" = "/persist/var/lib/bitwarden_rs"; } else { })
       // (if config.hardware.bluetooth.enable then { "/var/lib/bluetooth" = "/persist/var/lib/bluetooth"; } else { })
       // (if config.virtualisation.libvirtd.enable then { "/var/lib/libvirt" = "/persist/var/lib/libvirt"; } else { })
       // (if config.security.acme.certs != { } then { "/var/lib/acme" = "/persist/var/lib/acme"; } else { });
in {
  boot.initrd.postDeviceCommands = (mkAfter ''
    zfs rollback -r ${config.fileSystems."/".device}@empty
  '');

  fileSystems = (mapAttrs (_: device: {
    inherit device;
    options = [ "bind" ];
  }) bindmount-paths) // {
    "/var/lib/redis-rspamd" = {
      device = "/persist/var/lib/redis-rspamd";
      options = [ "bind" ];
    };
  };

  services.mysql.dataDir = "/persist/var/lib/mysql";
  services.postgresql.dataDir = "/persist/postgresql/${config.services.postgresql.package.psqlSchema}";
  services.hedgedoc.workDir = "/persist/var/lib/hedgedoc";
  services.grocy.dataDir = "/persist/var/lib/grocy";
  services.paperless.dataDir = "/persist/var/lib/paperless";
  services.netbox.dataDir = "/persist/var/lib/netbox";
  services.nextcloud.home = "/persist/var/lib/nextcloud";
  services.firefly-iii.dataDir = "/persist/var/lib/firefly-iii";
  services.snipe-it.dataDir = "/persist/var/lib/snipe-it";

  services.openssh.hostKeys = [
    {
      bits = 4096;
      path = "/persist/etc/ssh/ssh_host_rsa_key";
      type = "rsa";
    }
    {
      path = "/persist/etc/ssh/ssh_host_ed25519_key";
      type = "ed25519";
    }
  ];
  sops.age.sshKeyPaths = [ "/persist/etc/ssh/ssh_host_ed25519_key" ];
}
