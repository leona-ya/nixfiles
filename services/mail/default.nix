{ config, inputs, pkgs, ... }:

{
  imports = [
    (fetchGit {
      url = "ssh://git@git.em0lar.dev:2222/em0lar/nixfiles-mail-secrets.git";
      rev = "4b0bafb017e6ea0500d28481dad8112e16de188b";
      ref = "main";
    }).outPath
    ./autoconfig.nix
  ];

  em0lar.secrets."mail/superusers".owner = "dovecot2";

  fileSystems."/var/vmail" = {
    device = "/mnt/cryptmail/vmail";
    options = [ "bind" ];
  };

  security.acme.certs."${config.networking.hostName}.${config.networking.domain}".extraDomainNames = [
    "mail.em0lar.dev"
  ];
  mailserver = {
    enable = true;
    fqdn = "${config.networking.hostName}.${config.networking.domain}";
    messageSizeLimit = 52428800;

    enableImap = false;
    enableSubmission = true;
    enablePop3 = false;
    enablePop3Ssl = false;

    dkimKeyBits = 2048;

    localDnsResolver = false;
    certificateScheme = 3;
  };

  services.dovecot2 = {
    extraConfig = ''
      auth_master_user_separator = *
      passdb {
        driver = passwd-file
        args = ${config.em0lar.secrets."mail/superusers".path}
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
