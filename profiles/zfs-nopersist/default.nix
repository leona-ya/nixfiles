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
    ])) // (if config.services.opendkim.enable then { "/var/dkim" = "/persist/var/dkim"; } else { })
       // (if config.services.dovecot2.enable then { "/var/lib/dovecot" = "/persist/var/lib/dovecot"; "/var/sieve" = "/persist/var/sieve"; } else { })
       // (if config.hardware.bluetooth.enable then { "/var/lib/bluetooth" = "/persist/var/lib/bluetooth"; } else { })
       // (if config.virtualisation.libvirtd.enable then { "/var/lib/libvirt" = "/persist/var/lib/libvirt"; } else { })
       // (if config.security.acme.certs != { } then { "/var/lib/acme" = "/persist/var/lib/acme"; } else { });
in {
  boot.initrd.postDeviceCommands = (mkAfter ''
    zfs rollback -r ${config.fileSystems."/".device}@empty
  '');

  fileSystems = mapAttrs (_: device: {
    inherit device;
    options = [ "bind" ];
  }) bindmount-paths;

  services.postgresql.dataDir = "/persist/postgresql/${config.services.postgresql.package.psqlSchema}";
  services.hedgedoc.workDir = "/persist/var/lib/hedgedoc";
  services.grocy.dataDir = "/persist/var/lib/grocy";
  services.paperless.dataDir = "/persist/var/lib/paperless";
  services.netbox.dataDir = "/persist/var/lib/netbox";
}

