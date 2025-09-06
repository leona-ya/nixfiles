{
  config,
  pkgs,
  lib,
  ...
}:

{
  l.sops.secrets."services/ldap/root_password".owner = "openldap";

  networking.firewall.interfaces."br-lan".allowedTCPPorts = [ 636 ];
  security.acme.certs."ldap.leona.is".group = "openldap";

  systemd.services.openldap = {
    wants = [ "acme-ldap.int.leona.is.service" ];
    after = [ "acme-ldap.int.leona.is.service" ];
  };

  services.openldap = {
    enable = true;
    urlList = [ "ldaps:///" ];
    settings = {
      attrs = {
        objectClass = "olcGlobal";
        cn = "config";
        olcPidFile = "/run/openldap/openldap.pid";
        olcTLSCACertificateFile = "/var/lib/acme/ldap.leona.is/full.pem";
        olcTLSCertificateFile = "/var/lib/acme/ldap.leona.is/cert.pem";
        olcTLSCertificateKeyFile = "/var/lib/acme/ldap.leona.is/key.pem";
        olcTLSCipherSuite = "DEFAULT:!kRSA:!kDHE";
        olcTLSProtocolMin = "3.3";
      };
      children = {
        "cn=schema" = {
          attrs = {
            cn = "schema";
            objectClass = "olcSchemaConfig";
          };
          includes = [
            "${pkgs.openldap}/etc/schema/core.ldif"
            "${pkgs.openldap}/etc/schema/cosine.ldif"
            "${pkgs.openldap}/etc/schema/inetorgperson.ldif"
            "${pkgs.openldap}/etc/schema/nis.ldif"
          ];
        };
        "cn=module{0}".attrs = {
          objectClass = "olcModuleList";
          olcModuleLoad = [ "argon2" ];
        };
        "olcDatabase={-1}frontend" = {
          attrs = {
            objectClass = [
              "olcDatabaseConfig"
              "olcFrontendConfig"
            ];
            olcDatabase = "{-1}frontend";
            olcAccess = [
              "{0}to * by dn.exact=gidNumber=0+uidNumber=0,cn=peercred,cn=external,cn=auth manage by * break"
            ];
            olcPasswordHash = "{ARGON2}";
          };
        };
        "olcDatabase={0}config" = {
          attrs = {
            objectClass = "olcDatabaseConfig";
            olcDatabase = "{0}config";
            olcAccess = [ "{0}to * by * none break" ];
          };
        };
        "olcDatabase={1}mdb" = {
          attrs = {
            objectClass = [
              "olcDatabaseConfig"
              "olcMdbConfig"
            ];
            olcDatabase = "{1}mdb";
            olcDbDirectory = "/var/lib/openldap/db";
            olcSuffix = "dc=leona,dc=is";
            olcRootDN = "cn=root,dc=leona,dc=is";
            olcRootPW = {
              path = config.sops.secrets."services/ldap/root_password".path;
            };
            olcAccess = [
              "{0}to attrs=userPassword
                by anonymous auth
                by self write
                by dn.children=\"ou=services,dc=leona,dc=is\" write
                by * none"
              "{1}to *
                by dn.children=\"ou=services,dc=leona,dc=is\" write
                by self read
                by * none"
            ];
          };
          children = {
            "olcOverlay={2}ppolicy" = {
              attrs = {
                objectClass = [
                  "olcOverlayConfig"
                  "olcPPolicyConfig"
                  "top"
                ];
                olcOverlay = "{2}ppolicy";
                olcPPolicyHashCleartext = "TRUE";
              };
            };
          };
        };
      };
    };
  };
}
