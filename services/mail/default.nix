{
  config,
  ...
}:

{
  imports = [
    (fetchGit {
      url = "gitlab@forkspace.net:leona/nixfiles-mail-secrets.git";
      rev = "666364492dffa4c87a1a29cc5e42d9344fd0fbdf";
      ref = "main";
    }).outPath
    ./autoconfig.nix
  ];

  security.acme.certs."${config.networking.fqdn}".extraDomainNames = [
    # Clean up as soon as turingmachine is deprecated
    "mail.em0lar.dev"
    "mail.leona.is"
    "mail.maroni.me"
    "mail.infinitespace.dev"
  ];
  mailserver = {
    enable = true;
    stateVersion = 3;
    fqdn = config.networking.fqdn;
    messageSizeLimit = 52428800;

    enableImap = false;
    enableSubmission = true;
    enablePop3 = false;
    enablePop3Ssl = false;

    dkimKeyBits = 2048;

    localDnsResolver = false;
    lmtpSaveToDetailMailbox = false;
    x509.useACMEHost = config.networking.fqdn;
  };

  services.nginx.virtualHosts = {
    "${config.networking.fqdn}" = {
      forceSSL = true;
      useACMEHost = config.networking.fqdn;
      locations."/".root = ./web-contact;
    };
  };

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
