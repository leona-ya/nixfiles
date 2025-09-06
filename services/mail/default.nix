{
  config,
  inputs,
  pkgs,
  ...
}:

{
  imports = [
    (fetchGit {
      url = "gitlab@forkspace.net:leona/nixfiles-mail-secrets.git";
      rev = "3e684e9364a045fca5ebbef18f44d8f33d7d6690";
      ref = "main";
    }).outPath
    ./autoconfig.nix
  ];

  l.sops.secrets."services/mail/users/superusers".owner = "dovecot2";

  security.acme.certs."${config.networking.hostName}.net.leona.is".extraDomainNames = [
    "mail.em0lar.dev"
    "mail.leona.is"
    "mail.maroni.me"
  ];
  mailserver = {
    enable = true;
    stateVersion = 3;
    fqdn = "${config.networking.hostName}.net.leona.is";
    messageSizeLimit = 52428800;

    enableImap = false;
    enableSubmission = true;
    enablePop3 = false;
    enablePop3Ssl = false;

    dkimKeyBits = 2048;

    localDnsResolver = false;
    certificateScheme = "acme";
    lmtpSaveToDetailMailbox = "no";
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
          "BAYES_HAM" { weight = -4; }
          "BAYES_SPAM" { weight = 6.5; }
        }'';
      "multimap.conf".text = ''
        BAD_SUBJECT_BL {
          type = "header";
          header = "subject";
          regexp = true;
          map = "${./bad_subject_map.inc}";
          description = "Blacklist for common spam subjects";
          score = 10; 
        }
      '';
    };
    extraConfig = ''
      actions {
        reject = 15;
        add_header = 7;
        greylist = 5;
      }
    '';
  };
}
