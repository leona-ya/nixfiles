{ config, inputs, pkgs, ... }:

{
  imports = [
    (fetchGit {
      url = "ssh://gitlab@cyberchaos.dev:62954/leona/nixfiles-mail-secrets.git";
      rev = "58dbb12213a5433861fed04ee3725614fb1eed68";
      ref = "main";
    }).outPath
    ./autoconfig.nix
  ];

  l.sops.secrets."services/mail/users/superusers".owner = "dovecot2";

  security.acme.certs."${config.networking.hostName}.net.leona.is".extraDomainNames = [
    "mail.em0lar.dev"
    "mail.leona.is"
  ];
  mailserver = {
    enable = true;
    fqdn = "${config.networking.hostName}.net.leona.is";
    messageSizeLimit = 52428800;

    enableImap = false;
    enableSubmission = true;
    enablePop3 = false;
    enablePop3Ssl = false;

    dkimKeyBits = 2048;

    localDnsResolver = false;
    certificateScheme = "acme-nginx";
  };

  services.dovecot2 = {
    extraConfig = ''
      auth_master_user_separator = *
      passdb {
        driver = passwd-file
        args = ${config.sops.secrets."services/mail/users/superusers".path}
        master = yes
        result_success = continue
      }
    '';
  };

#  services.rspamd.workers.controller = {
#    bindSockets = [{
#      socket = "127.0.0.1:11334";
#    }];
#    extraConfig = ''
#      secure_ip = "127.0.0.1"
#    '';
#  };
  services.rspamd = {
    locals = {
      "groups.conf".text = ''
        symbols {
          "FORGED_RECIPIENTS" { weight = 0; }
          "FORGED_SENDER" { weight = 0; }
        }'';
    };
    extraConfig = ''
      actions {
        reject = 15;
        add_header = 8;
        greylist = 6;
      }
    '';
  };
  services.nginx.virtualHosts = {
    "mail.em0lar.dev" = {
      enableACME = true;
      forceSSL = true;
      serverAliases = [
        "mail.leona.is"
      ];
      #locations."/rspamd/" = {
      #  proxyPass = "http://unix:/var/run/rspamd/worker-controller.sock:/";
      #  extraConfig = ''
      #    proxy_set_header Host      $host;
      #    proxy_set_header X-Real-IP $remote_addr;
      #    proxy_set_header X-Forwarded-For "";
      #  '';
      #};
    };
  };
}
