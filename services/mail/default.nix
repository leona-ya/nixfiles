{ config, inputs, pkgs, ... }:

{
  imports = [
    (fetchGit {
      url = "ssh://git@git.em0lar.dev:2222/em0lar/nixfiles-mail-secrets.git";
      rev = "6bbef181479224a6a059f094a96bed4559a15541";
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
    enableSubmission = false;
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
